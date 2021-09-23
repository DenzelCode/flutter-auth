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
  final String roomId;
  final Room room;
  final bool isDialog;

  RoomCheckSuccess(this.roomId, this.room, {this.isDialog = false}) : super();
}
