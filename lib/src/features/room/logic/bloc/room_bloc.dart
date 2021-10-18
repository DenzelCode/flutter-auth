import 'dart:async';

import 'package:auth/src/core/socket.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:auth/src/features/room/logic/repository/room_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final repository = RoomRepository();
  final socket = socketManager.socket;

  Timer? updateRoomTimer;
  String? joinedRoomId;

  RoomBloc() : super(RoomInitialState()) {
    initEvents();
  }

  void initEvents() {
    on<RoomCheckedEvent>(_onRoomChecked);
    on<RoomJoinedEvent>(_onRoomJoined);
    on<RoomUserJoinEvent>(_onRoomUserJoin);
    on<RoomUserLeaveEvent>(_onRoomUserLeave);
    on<SocketDisconnectedEvent>(_onSocketDisconnected);
    on<SocketConnectedEvent>(_onRoomConnected);

    on<DirectRoomDeletedEvent>(
      (event, emit) => emit.call(DirectRooomDeleteState()),
    );

    on<DirectRoomUpdatedEvent>(
      (event, emit) => emit.call(RoomJoinSuccessState(event.room)),
    );
  }

  void initTimers() {
    updateRoomTimer = Timer.periodic(
      Duration(seconds: 5),
      (_) => add(RoomCheckedEvent(joinedRoomId as String)),
    );
  }

  void initSocket() {
    socket.onDisconnect((data) => add(SocketDisconnectedEvent()));

    socket.onConnect((data) => add(SocketConnectedEvent()));

    socket.on(
      'room:join',
      (data) => add(RoomUserJoinEvent(User.fromJson(data))),
    );

    socket.on(
      'room:leave',
      (data) => add(RoomUserLeaveEvent(User.fromJson(data))),
    );

    socket.on(
      'room:update',
      (data) => add(DirectRoomUpdatedEvent(Room.fromJson(data))),
    );

    socket.on('room:delete', (data) => add(DirectRoomDeletedEvent()));

    if (!socket.connected) {
      socketManager.init(
        () => socket.emit('room:subscribe', joinedRoomId),
      );
    }
  }

  @override
  Future<void> close() {
    socketManager.dispose();

    updateRoomTimer?.cancel();

    return super.close();
  }

  FutureOr<void> _onRoomChecked(
    RoomCheckedEvent event,
    Emitter<RoomState> emit,
  ) async {
    if (state is RoomCheckInProgressState) {
      return;
    }

    if (state is RoomInitialState || joinedRoomId == null) {
      emit.call(RoomCheckInProgressState());
    }

    try {
      final room = await repository.getRoom(event.roomId);

      if (state is SocketConnectState) {
        emit.call(SocketConnectState(room));
      } else {
        emit.call(RoomCheckSuccessState(room, isDialog: event.isDialog));
      }
    } catch (e) {
      emit.call(RoomCheckFailureState());
    }
  }

  FutureOr<void> _onRoomJoined(
    RoomJoinedEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit.call(RoomJoinInProgressState());

    try {
      final room = await repository.joinRoom(event.roomId);

      joinedRoomId = room.id;

      emit.call(RoomJoinSuccessState(room));

      initSocket();

      initTimers();
    } catch (e) {
      emit.call(RoomJoinFailureState());
    }
  }

  FutureOr<void> _onRoomUserJoin(
    RoomUserJoinEvent event,
    Emitter<RoomState> emit,
  ) {
    if (!(state is RoomParamState)) {
      return null;
    }

    final data = state as RoomParamState;

    emit.call(RoomJoinSuccessState(
      data.room.copyWith(members: [...data.room.members, event.user]),
    ));
  }

  FutureOr<void> _onRoomUserLeave(
    RoomUserLeaveEvent event,
    Emitter<RoomState> emit,
  ) {
    if (!(state is RoomParamState)) {
      return null;
    }

    final data = state as RoomParamState;

    emit.call(
      RoomJoinSuccessState(data.room.copyWith(
        members: data.room.members.where((e) => e.id != event.user.id).toList(),
      )),
    );
  }

  FutureOr<void> _onRoomConnected(
    SocketConnectedEvent event,
    Emitter<RoomState> emit,
  ) {
    if (!(state is RoomParamState)) {
      return null;
    }

    final data = state as RoomParamState;

    emit.call(SocketConnectState(data.room));
  }

  FutureOr<void> _onSocketDisconnected(
    SocketDisconnectedEvent event,
    Emitter<RoomState> emit,
  ) {
    if (!(state is RoomParamState)) {
      return null;
    }

    final data = state as RoomParamState;

    emit.call(SocketDisconnectState(data.room));
  }
}
