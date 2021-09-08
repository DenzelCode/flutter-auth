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

      yield RoomsLoadSuccess(
        memberRooms: data.memberRooms,
        publicRooms: data.publicRooms,
        userRooms: List.from(data.userRooms)..add(room),
      );
    }
  }
}
