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

class SocketDisconnectedEvent extends RoomEvent {}

class SocketConnectedEvent extends RoomEvent {}

class DirectRoomDeletedEvent extends RoomEvent {}

class _UserEvent extends RoomEvent {
  final User user;

  _UserEvent(this.user) : super();

  @override
  List<Object> get props => [user];
}

class RoomUserJoinEvent extends _UserEvent {
  RoomUserJoinEvent(User user) : super(user);
}

class RoomUserLeaveEvent extends _UserEvent {
  RoomUserLeaveEvent(User user) : super(user);
}

class DirectRoomUpdatedEvent extends _RoomObjectParamEvent {
  DirectRoomUpdatedEvent(Room room) : super(room);
}

class UpdateRoomInfoEvent extends RoomEvent {}
