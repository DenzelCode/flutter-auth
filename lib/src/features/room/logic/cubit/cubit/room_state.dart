part of 'room_cubit.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomCheckInProgress extends RoomState {}

class RoomCheckFailure extends RoomState {}

class RoomCheckSuccess extends RoomState {
  final Room room;
  final bool isDialog;

  RoomCheckSuccess(this.room, {this.isDialog = false}) : super();
}

class RoomJoinInProgress extends RoomState {}

class RoomJoinFailure extends RoomState {}

class RoomJoinSuccess extends RoomState {
  final Room room;

  RoomJoinSuccess(this.room) : super();
}
