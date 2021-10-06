import 'dart:async';

import 'package:auth/src/core/socket.dart';
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

  RoomBloc({required this.repository}) : super(RoomInitialState()) {
    on<RoomCheckedEvent>(_onRoomChecked);
    on<RoomJoinedEvent>(_onRoomJoined);

    socket.onDisconnect((data) => this.emit(RoomJoinInProgressState()));
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
      emit.call(RoomCheckFailureStqte());
    }
  }

  FutureOr<void> _onRoomJoined(
    RoomJoinedEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit.call(RoomJoinInProgressState());

    try {
      final room = await repository.joinRoom(event.roomId);

      await socketManager.init(
        () => socket.emit('room:subscribe', event.roomId),
      );

      lastRoom = room;

      emit.call(RoomJoinSuccessState(room));
    } catch (e) {
      emit.call(RoomJoinFailureState());
    }
  }

  @override
  Future<void> close() {
    socketManager.dispose();

    return super.close();
  }
}
