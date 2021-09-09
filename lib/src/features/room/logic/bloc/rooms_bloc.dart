import 'dart:async';

import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:auth/src/features/room/logic/repository/room_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  RoomRepository repository;

  RoomsBloc({required this.repository}) : super(RoomsLoadInProgress());

  @override
  Stream<RoomsState> mapEventToState(
    RoomsEvent event,
  ) async* {
    if (event is RoomsLoaded) {
      yield* _mapRoomsLoadedToState(event);
    } else if (event is RoomCreated) {
      yield* _mapRoomCreatedToState(event);
    } else if (event is RoomUpdated) {
      yield* _mapRoomUpdatedToState(event);
    } else if (event is RoomUpdated) {
      yield* _mapRoomUpdatedToState(event);
    } else if (event is RoomDeleted) {
      yield* _mapRoomDeletedToState(event);
    }
  }

  Stream<RoomsState> _mapRoomsLoadedToState(RoomsLoaded event) async* {
    yield RoomsLoadInProgress();

    try {
      final userRooms = await repository.getUserRooms();
      final memberRooms = await repository.getRoomsByMember();
      final publicRooms = await repository.getPublicRooms();

      yield RoomsLoadSuccess(
        userRooms: userRooms,
        memberRooms: memberRooms,
        publicRooms: publicRooms,
      );
    } catch (e) {
      yield RoomsLoadFailure();
    }
  }

  Stream<RoomsState> _mapRoomCreatedToState(RoomCreated event) async* {
    if (state is RoomsLoadSuccess) {
      final data = state as RoomsLoadSuccess;

      final room = await repository.createRoom(
        title: event.title,
        isPublic: event.isPublic,
      );

      List<Room> publicRooms = List.from(data.publicRooms);

      if (event.isPublic) {
        publicRooms.add(room);
      }

      yield RoomsLoadSuccess(
        memberRooms: data.memberRooms,
        publicRooms: publicRooms,
        userRooms: List.from(data.userRooms)..add(room),
      );
    }
  }

  Stream<RoomsState> _mapRoomUpdatedToState(RoomUpdated event) async* {
    if (state is RoomsLoadSuccess) {
      final data = state as RoomsLoadSuccess;

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

      yield RoomsLoadSuccess(
        memberRooms: data.memberRooms.map(replaceHandler).toList(),
        publicRooms: data.publicRooms
            .map(replaceHandler)
            .where((e) => e.isPublic)
            .toList(),
        userRooms: data.userRooms.map(replaceHandler).toList(),
      );
    }
  }

  Stream<RoomsState> _mapRoomDeletedToState(RoomDeleted event) async* {
    if (state is RoomsLoadSuccess) {
      final data = state as RoomsLoadSuccess;

      await repository.deleteRoom(event.id);

      final deleteHandler = (Room e) => e.id != event.id;

      yield RoomsLoadSuccess(
        memberRooms: data.memberRooms.where(deleteHandler).toList(),
        publicRooms: data.publicRooms.where(deleteHandler).toList(),
        userRooms: data.userRooms.where(deleteHandler).toList(),
      );
    }
  }
}
