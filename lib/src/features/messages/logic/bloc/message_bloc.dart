import 'dart:async';

import 'package:auth/src/core/socket.dart';
import 'package:auth/src/features/messages/logic/enum/message_type.dart';
import 'package:auth/src/features/messages/logic/models/message.dart';
import 'package:auth/src/features/messages/logic/repository/message_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final String partnerId;

  final MessageType type;

  final Socket socket = socketManager.socket;

  final repository = MessageRepository();

  final limit = 30;

  bool loading = false;

  Message? firstMessage;

  MessageBloc({
    required this.partnerId,
    required this.type,
  }) : super(MessageInitial()) {
    initEvents();

    initSockets();
  }

  void initEvents() {
    on<MessagesLoadedEvent>(_onMessagesLoaded);
    on<PreviousMessagesLoadedEvent>(_onPreviousMessagesLoaded);
    on<UserTypedEvent>(_onUserTyped);
    on<MessageSentEvent>(_onMessageSent);
    on<MessageReceivedEvent>(_onMessageReceived);
    on<MessagesDeletedEvent>(_onMessagesDeleted);
    on<MessageDeletedEvent>(_onMessageDeleted);
  }

  void initSockets() {
    socket.on('message:${type.name}', (data) {
      add(MessageReceivedEvent(Message.fromJson(data)));
    });

    socket.on(
        '${type.name}:delete_messages', (data) => add(MessagesDeletedEvent()));

    socket.on('${type.name}:delete_message',
        (messageId) => add(MessageDeletedEvent(messageId)));

    socket.on('message:${type.name}:typing', (data) {});
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
    UserTypedEvent event,
    Emitter<MessageState> emit,
  ) {}

  FutureOr<void> _onMessageSent(
    MessageSentEvent event,
    Emitter<MessageState> emit,
  ) {}

  FutureOr<void> _onMessageReceived(
    MessageReceivedEvent event,
    Emitter<MessageState> emit,
  ) {
    final data = state as MessagesState;

    data.messages.add(event.message);

    emit.call(MessageReceiveState([...data.messages]));
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

    emit.call(MessagesLoadSuccessState(
        data.messages.where((e) => e.id == event.messageId).toList()));
  }

  @override
  Future<void> close() {
    socketManager.dispose();

    return super.close();
  }
}
