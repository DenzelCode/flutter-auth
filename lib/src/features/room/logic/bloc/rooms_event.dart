part of 'rooms_bloc.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();

  @override
  List<Object> get props => [];
}

class RoomsLoadedEvent extends RoomsEvent {}

class _RoomParamsEvent extends RoomsEvent {
  final String title;
  final bool isPublic;

  _RoomParamsEvent({required this.title, required this.isPublic});

  @override
  List<Object> get props => [title, isPublic];
}

class RoomCreatedEvent extends _RoomParamsEvent {
  RoomCreatedEvent({required String title, required bool isPublic})
      : super(title: title, isPublic: isPublic);
}

class RoomUpdatedEvent extends _RoomParamsEvent {
  final String id;

  RoomUpdatedEvent({
    required this.id,
    required String title,
    required bool isPublic,
  }) : super(title: title, isPublic: isPublic);

  @override
  List<Object> get props => [id, ...super.props];
}

class RoomDeletedEvent extends RoomsEvent {
  final String id;

  RoomDeletedEvent(this.id);

  @override
  List<Object> get props => [id];
}

class RoomLeftEvent extends RoomsEvent {
  final String id;

  RoomLeftEvent(this.id);

  @override
  List<Object> get props => [id];
}
