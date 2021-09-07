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
}
