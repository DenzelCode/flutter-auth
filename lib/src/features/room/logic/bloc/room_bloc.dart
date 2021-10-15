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
  final RoomRepository repository;

  final Socket socket = socketManager.socket;

  Room? lastRoom;

  int connections = 0;

  Timer? timer;

  RoomBloc({required this.repository}) : super(RoomInitialState()) {
    initEvents();
  }

  void initEvents() {
    on<RoomCheckedEvent>(_onRoomChecked);
    on<RoomJoinedEvent>(_onRoomJoined);
    on<RoomUserJoinEvent>(_onRoomUserJoin);
    on<UpdateRoomInfoEvent>(_onRoomInfoUpdated);
    on<RoomDisconnectedEvent>(
        (event, emit) => emit.call(RoomJoinInProgressState()));
    on<RoomReconnectedEvent>(
        (event, emit) => emit.call(RoomJoinSuccessState(event.room)));
    on<DirectRoomDeletedEvent>(
        (event, emit) => emit.call(DirectRooomDeleteState()));
    on<DirectRoomUpdatedEvent>(
        (event, emit) => emit.call(RoomJoinSuccessState(event.room)));

    timer = Timer(Duration(seconds: 5), () {
      if (lastRoom == null) {
        return;
      }

      add(UpdateRoomInfoEvent(lastRoom as Room));
    });
  }

  void initSocket() {
    socket.onDisconnect((data) => add(RoomDisconnectedEvent()));

    socket.onConnect((data) {
      connections++;

      if (connections > 1) {
        add(RoomReconnectedEvent(lastRoom as Room));
      }
    });

    socket.on(
      'room:join',
      (data) => add(RoomUserJoinEvent(User.fromJson(data))),
    );

    socket.on(
      'room:leave',
      (data) => (data) => add(RoomUserLeaveEvent(User.fromJson(data))),
    );

    socket.on('room:update', (data) {
      final room = Room.fromJson(data);

      if (room.id != lastRoom?.id) {
        return;
      }

      add(DirectRoomUpdatedEvent(room));
    });

    socket.on('room:delete', (data) {
      final room = Room.fromJson(data);

      if (room.id != lastRoom?.id) {
        return;
      }

      add(DirectRoomDeletedEvent());
    });
  }

  @override
  Future<void> close() {
    socketManager.dispose();

    timer?.cancel();

    return super.close();
  }

  FutureOr<void> _onRoomChecked(
    RoomCheckedEvent event,
    Emitter<RoomState> emit,
  ) async {
    if (state is RoomCheckInProgressState) {
      return;
    }

    emit.call(RoomCheckInProgressState());

    try {
      emit.call(RoomCheckSuccessState(
        await repository.getRoom(event.roomId),
        isDialog: event.isDialog,
      ));
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

      initSocket();

      await socketManager.init(
        () => socket.emit('room:subscribe', event.roomId),
      );

      lastRoom = room;

      emit.call(RoomJoinSuccessState(room));
    } catch (e) {
      emit.call(RoomJoinFailureState());
    }
  }

  FutureOr<void> _onRoomUserJoin(
    RoomUserJoinEvent event,
    Emitter<RoomState> emit,
  ) {
    final data = state as RoomJoinSuccessState;

    final room = data.room;

    room.members.add(event.user);

    emit.call(RoomJoinSuccessState(room));
  }

  FutureOr<void> _onRoomInfoUpdated(
    UpdateRoomInfoEvent event,
    Emitter<RoomState> emit,
  ) async {
    if (state is RoomCheckInProgressState) {
      return;
    }

    try {
      emit.call(RoomJoinSuccessState(
        await repository.getRoom(event.room.id),
      ));
    } catch (e) {
      emit.call(RoomCheckFailureState());
    }
  }
}
