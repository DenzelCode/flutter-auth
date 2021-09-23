import 'package:auth/src/features/room/logic/repository/room_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final RoomRepository repository;

  RoomCubit({required this.repository}) : super(RoomInitial());

  Future<void> joinRoom(String roomId, {bool isDialog = false}) async {
    if (state is RoomJoinInProgress) {
      return;
    }

    emit(RoomJoinInProgress());

    try {
      await repository.joinRoom(roomId);

      emit(RoomJoinSuccess(roomId, isDialog: isDialog));
    } catch (e) {
      emit(RoomJoinFailure());
    }
  }
}
