import 'dart:async';

import 'package:auth/src/core/socket.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/user/logic/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'direct_message_event.dart';
part 'direct_message_state.dart';

class DirectMessageBloc extends Bloc<DirectMessageEvent, DirectMessageState> {
  final String username;

  final _userRepository = UserRepository();

  final Socket socket = socketManager.socket;

  Timer? updateTimer;

  final bool fromMessages;

  DirectMessageBloc(this.username, {this.fromMessages = false})
      : super(DirectMessageInitialState()) {
    initEvents();
  }

  void initSockets() {
    socket.onConnect((_) => add(SocketConnectedEvent()));

    if (socket.connected) {
      add(SocketConnectedEvent());
    }

    socket.onDisconnect((_) => add(SocketDisconnectedEvent()));

    socket.connect();
  }

  void initEvents() {
    on<UserLoadedEvent>(_onLoaded);
    on<SocketConnectedEvent>(_onConnected);
    on<SocketDisconnectedEvent>(_onDisconnected);

    updateTimer = Timer.periodic(
      Duration(seconds: 5),
      (_) => add(UserLoadedEvent()),
    );
  }

  FutureOr<void> _onLoaded(
    UserLoadedEvent event,
    Emitter<DirectMessageState> emit,
  ) async {
    if (state is UserLoadInProgressState) {
      return;
    }

    final isInitial = state is DirectMessageInitialState;

    if (isInitial) {
      emit.call(UserLoadInProgressState());
    }

    try {
      final user = await _userRepository.getUser(username);

      if (state is SocketConnectState) {
        emit.call(SocketConnectState(user));
      } else {
        emit.call(UserLoadSuccessState(user));

        if (isInitial) {
          initSockets();
        }
      }
    } catch (_) {
      emit.call(UserLoadFailureState());
    }
  }

  @override
  Future<void> close() {
    updateTimer?.cancel();

    if (!fromMessages) {
      socketManager.dispose();
    }

    return super.close();
  }

  FutureOr<void> _onConnected(
    SocketConnectedEvent event,
    Emitter<DirectMessageState> emit,
  ) {
    final data = state as DirectUserState;

    emit.call(SocketConnectState(data.user));
  }

  FutureOr<void> _onDisconnected(
    SocketDisconnectedEvent event,
    Emitter<DirectMessageState> emit,
  ) {
    final data = state as DirectUserState;

    emit.call(SocketDisconnectState(data.user));
  }
}
