import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:auth/src/features/room/logic/repository/room_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final RoomRepository repository;

  RoomCubit({required this.repository}) : super(RoomInitial());

  Future<void> checkRoom(String roomId, {bool isDialog = false}) async {
    if (state is RoomCheckInProgress) {
      return;
    }

    emit(RoomCheckInProgress());

    try {
      emit(RoomCheckSuccess(
        await repository.getRoom(roomId),
        isDialog: isDialog,
      ));
    } catch (e) {
      emit(RoomCheckFailure());
    }
  }

  Future<void> joinRoom(String roomId, {bool isDialog = false}) async {
    if (state is RoomCheckInProgress) {
      return;
    }

    emit(RoomJoinInProgress());

    try {
      emit(RoomJoinSuccess(await repository.joinRoom(roomId)));
    } catch (e) {
      emit(RoomJoinFailure());
    }
  }
}
