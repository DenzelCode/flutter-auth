part of 'room_bloc.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitialState extends RoomState {}

class RoomCheckInProgressState extends RoomState {}

class RoomCheckFailureState extends RoomState {}

class _RoomParamState extends RoomState {
  final Room room;

  _RoomParamState(this.room) : super();

  @override
  List<Object> get props => [room];
}

class RoomCheckSuccessState extends _RoomParamState {
  final bool isDialog;

  RoomCheckSuccessState(Room room, {this.isDialog = false}) : super(room);

  @override
  List<Object> get props => [...super.props, isDialog];
}

class RoomJoinInProgressState extends RoomState {}

class RoomJoinFailureState extends RoomState {}

class RoomJoinSuccessState extends _RoomParamState {
  RoomJoinSuccessState(Room room) : super(room);
}

class DirectRooomDeleteState extends RoomState {}
