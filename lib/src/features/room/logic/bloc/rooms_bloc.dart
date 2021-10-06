import 'dart:async';

import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:auth/src/features/room/logic/repository/room_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  RoomRepository repository;

  RoomsBloc({required this.repository}) : super(RoomsLoadInProgressState()) {
    on<RoomsLoadedEvent>(_onRoomsLoaded);
    on<RoomCreatedEvent>(_onRoomCreated);
    on<RoomUpdatedEvent>(_onRoomUpdated);
    on<RoomDeletedEvent>(_onRoomDeleted);
    on<RoomLeftEvent>(_onRoomLeft);
  }

  FutureOr<void> _onRoomsLoaded(
    RoomsLoadedEvent event,
    Emitter<RoomsState> emit,
  ) async {
    emit.call(RoomsLoadInProgressState());

    try {
      final userRooms = await repository.getUserRooms();
      final memberRooms = await repository.getRoomsByMember();
      final publicRooms = await repository.getPublicRooms();

      emit.call(RoomsLoadSuccessState(
        userRooms: userRooms,
        memberRooms: memberRooms,
        publicRooms: publicRooms,
      ));
    } catch (e) {
      emit.call(RoomsLoadFailureState());
    }
  }

  FutureOr<void> _onRoomCreated(
    RoomCreatedEvent event,
    Emitter<RoomsState> emit,
  ) async {
    final data = state as RoomsLoadSuccessState;

    final room = await repository.createRoom(
      title: event.title,
      isPublic: event.isPublic,
    );

    List<Room> publicRooms = List.from(data.publicRooms);

    if (event.isPublic) {
      publicRooms.add(room);
    }

    emit.call(RoomsLoadSuccessState(
      memberRooms: data.memberRooms,
      publicRooms: publicRooms,
      userRooms: List.from(data.userRooms)..add(room),
    ));
  }

  FutureOr<void> _onRoomUpdated(
    RoomUpdatedEvent event,
    Emitter<RoomsState> emit,
  ) async {
    final data = state as RoomsLoadSuccessState;

    final response = await repository.updateRoom(
      event.id,
      title: event.title,
      isPublic: event.isPublic,
    );

    final room = Room(
      id: event.id,
      title: event.title,
      isPublic: event.isPublic,
      members: response.members,
      owner: response.owner,
    );

    if (room.isPublic && !data.publicRooms.any((e) => e.id == room.id)) {
      data.publicRooms.add(room);
    }

    final replaceHandler = (Room e) => event.id == e.id ? room : e;

    emit.call(RoomsLoadSuccessState(
      memberRooms: data.memberRooms.map(replaceHandler).toList(),
      publicRooms: data.publicRooms
          .map(replaceHandler)
          .where((e) => e.isPublic)
          .toList(),
      userRooms: data.userRooms.map(replaceHandler).toList(),
    ));
  }

  FutureOr<void> _onRoomDeleted(
    RoomDeletedEvent event,
    Emitter<RoomsState> emit,
  ) async {
    final data = state as RoomsLoadSuccessState;

    await repository.deleteRoom(event.id);

    final deleteHandler = (Room e) => e.id != event.id;

    emit.call(RoomsLoadSuccessState(
      memberRooms: data.memberRooms.where(deleteHandler).toList(),
      publicRooms: data.publicRooms.where(deleteHandler).toList(),
      userRooms: data.userRooms.where(deleteHandler).toList(),
    ));
  }

  FutureOr<void> _onRoomLeft(
    RoomLeftEvent event,
    Emitter<RoomsState> emit,
  ) async {
    final data = state as RoomsLoadSuccessState;

    await repository.leaveRoom(event.id);

    emit.call(RoomsLoadSuccessState(
      memberRooms:
          data.memberRooms.where((room) => room.id != event.id).toList(),
      publicRooms: data.publicRooms,
      userRooms: data.userRooms,
    ));
  }
}
