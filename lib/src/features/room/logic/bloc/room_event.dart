part of 'room_bloc.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class _RoomParamsEvent extends RoomEvent {
  final String roomId;

  _RoomParamsEvent(this.roomId);

  @override
  List<Object> get props => [roomId];
}

class RoomCheckedEvent extends _RoomParamsEvent {
  final bool isDialog;

  RoomCheckedEvent(String roomId, {this.isDialog = false}) : super(roomId);

  @override
  List<Object> get props => [...super.props, isDialog];
}

class RoomJoinedEvent extends _RoomParamsEvent {
  RoomJoinedEvent(String roomId) : super(roomId);
}

class _RoomObjectParamEvent extends RoomEvent {
  final Room room;

  _RoomObjectParamEvent(this.room);

  @override
  List<Object> get props => [room];
}

class RoomDisconnectedEvent extends RoomEvent {}

class RoomReconnectedEvent extends _RoomObjectParamEvent {
  RoomReconnectedEvent(Room room) : super(room);
}
