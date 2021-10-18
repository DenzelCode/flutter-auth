import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:auth/src/app.dart';
import 'package:auth/src/core/socket.dart';
import 'package:auth/src/features/auth/logic/cubit/auth_cubit.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/messages/logic/enum/message_type.dart';
import 'package:auth/src/features/messages/logic/models/message.dart';
import 'package:auth/src/features/messages/logic/models/typing.dart';
import 'package:auth/src/features/messages/logic/repository/message_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final String partnerId;
  final MessageType type;
  final socket = socketManager.socket;
  final repository = MessageRepository();

  final audioCache = AudioCache();

  final limit = 30;
  final typingTimeout = 5000;

  bool loading = false;
  Message? firstMessage;

  Map<String, Timer> typingTimers = {};

  final BuildContext context;

  User? currentUser;

  final bool fromMessages;

  MessageBloc({
    required this.partnerId,
    required this.type,
    required this.context,
    this.fromMessages = false,
  }) : super(MessageInitial()) {
    currentUser = context.read<AuthCubit>().state;

    initEvents();

    initSockets();
  }

  void initEvents() {
    on<MessagesLoadedEvent>(_onMessagesLoaded);
    on<PreviousMessagesLoadedEvent>(_onPreviousMessagesLoaded);
    on<MessageUserTypedEvent>(_onUserTyped);
    on<MessageSentEvent>(_onMessageSent);
    on<MessageReceivedEvent>(_onMessageReceived);
    on<MessagesDeletedEvent>(_onMessagesDeleted);
    on<MessageDeletedEvent>(_onMessageDeleted);
    on<MessageDeletedRequestEvent>(_onMessageDeletedRequest);
    on<TypingRemovedEvent>(_onTypingRemoved);
  }

  void initSockets() {
    socket.on(
      'message:${type.name}',
      (data) {
        final message = Message.fromJson(data);

        if (!_isCurrentPartner([
          message.to != currentUser?.id ? message.to : message.from.id,
          message.room
        ])) {
          return;
        }

        add(MessageReceivedEvent(message));
      },
    );

    socket.on(
      '${type.name}:delete_messages',
      (data) => add(MessagesDeletedEvent()),
    );

    socket.on(
      '${type.name}:delete_message',
      (messageId) => add(MessageDeletedEvent(messageId)),
    );

    socket.on(
      'message:${type.name}:typing',
      (data) {
        final typing = Typing.fromJson(data);

        if (!_isCurrentPartner([typing.room?.id, typing.user.id])) {
          return;
        }

        add(MessageUserTypedEvent(typing));
      },
    );
  }

  bool _isCurrentPartner([List<String?> partners = const []]) {
    for (final partner in partners) {
      if (partner == partnerId || currentUser?.id == partner) {
        return true;
      }
    }

    return false;
  }

  @override
  Future<void> close() {
    if (!fromMessages) {
      socketManager.dispose();
    }

    return super.close();
  }

  void createTimer(User user, Timer timer) {
    cancelTypingTimer(user);

    typingTimers[user.id] = timer;
  }

  void cancelTypingTimer(User user) {
    typingTimers[user.id]?.cancel();
  }

  void sendTyping() {
    socket.emit('message:${type.name}:typing', partnerId);
  }

  void sendMessage(String message, Function? awknowledge) {
    socket.emitWithAck(
      'message:${type.name}',
      {
        'roomId': partnerId,
        'to': partnerId,
        'message': message,
      },
      ack: awknowledge,
    );
  }

  FutureOr<void> _onMessagesLoaded(
    MessagesLoadedEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit.call(MessagesLoadInProgressState());

    try {
      final messages = await repository.getMessages(
        type: type,
        id: partnerId,
        limit: limit,
      );

      firstMessage = await repository.getFirstMessage(type, partnerId);

      emit.call(MessagesLoadSuccessState(messages));
    } catch (_) {
      emit.call(MessagesLoadFailureState());
    }
  }

  FutureOr<void> _onPreviousMessagesLoaded(
    PreviousMessagesLoadedEvent event,
    Emitter<MessageState> emit,
  ) async {
    final data = state as MessagesState;

    if (data.messages.length > 0 && data.messages[0].id == firstMessage?.id ||
        loading) {
      return;
    }

    loading = true;

    final messages = await repository.getMessages(
      type: type,
      id: partnerId,
      limit: limit,
      before: data.messages.length > 0 ? data.messages[0].createdAt : null,
    );

    emit.call(PreviousMessagesLoadState(
      [...messages, ...data.messages],
      event.previousScrollHeight,
    ));

    loading = false;
  }

  FutureOr<void> _onUserTyped(
    MessageUserTypedEvent event,
    Emitter<MessageState> emit,
  ) {
    if (!(state is MessagesState)) {
      return null;
    }

    final data = state as MessagesState;

    final user = event.typing.user;

    final context = MyApp.materialKey.currentContext;

    if (context == null) {
      return null;
    }

    final cubit = context.read<AuthCubit>();

    if (cubit.state?.id == user.id) {
      return null;
    }

    createTimer(
      user,
      Timer(
        Duration(milliseconds: typingTimeout),
        () => add(TypingRemovedEvent(user)),
      ),
    );

    emit.call(MessageTypingState(
      data.messages,
      [...data.usersTyping.where((e) => e.id != user.id).toList(), user],
    ));
  }

  FutureOr<void> _onMessageSent(
    MessageSentEvent event,
    Emitter<MessageState> emit,
  ) {}

  FutureOr<void> _onMessageReceived(
    MessageReceivedEvent event,
    Emitter<MessageState> emit,
  ) {
    final data = state as MessagesState;

    cancelTypingTimer(event.message.from);

    final currentUser = context.read<AuthCubit>().state;

    if (event.message.from.id != currentUser?.id) {
      audioCache.play('tones/message_tone.mp3', isNotification: true);
    }

    emit.call(MessageReceiveState(
      [
        ...data.messages,
        event.message,
      ],
      data.usersTyping.where((e) => e.id != event.message.from.id).toList(),
    ));
  }

  FutureOr<void> _onMessagesDeleted(
    MessagesDeletedEvent event,
    Emitter<MessageState> emit,
  ) {
    emit.call(MessagesLoadSuccessState([]));
  }

  FutureOr<void> _onMessageDeleted(
    MessageDeletedEvent event,
    Emitter<MessageState> emit,
  ) {
    final data = state as MessagesState;

    emit.call(MessageDeleteState(
      data.messages.where((e) => e.id != event.messageId).toList(),
    ));
  }

  FutureOr<void> _onTypingRemoved(
    TypingRemovedEvent event,
    Emitter<MessageState> emit,
  ) {
    final data = state as MessagesState;

    emit.call(MessageTypingState(
      [...data.messages],
      data.usersTyping.where((e) => e.id != event.user.id).toList(),
    ));
  }

  FutureOr<void> _onMessageDeletedRequest(
    MessageDeletedRequestEvent event,
    Emitter<MessageState> emit,
  ) {
    return repository.deleteMessage(type, event.message);
  }
}
