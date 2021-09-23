part of 'room_cubit.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomJoinInProgress extends RoomState {}

class RoomJoinFailure extends RoomState {}

class RoomJoinSuccess extends RoomState {
  final String roomId;
  final bool isDialog;

  RoomJoinSuccess(this.roomId, {this.isDialog = false}) : super();
}
