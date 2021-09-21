part of 'rooms_bloc.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();

  @override
  List<Object> get props => [];
}

class RoomsLoaded extends RoomsEvent {}

class RoomCreated extends RoomsEvent {
  final String title;
  final bool isPublic;

  RoomCreated({required this.title, required this.isPublic});

  @override
  List<Object> get props => [title, isPublic];
}

class RoomUpdated extends RoomsEvent {
  final String id;
  final String title;
  final bool isPublic;

  RoomUpdated({
    required this.id,
    required this.title,
    required this.isPublic,
  });

  @override
  List<Object> get props => [id, title, isPublic];
}

class RoomDeleted extends RoomsEvent {
  final String id;

  RoomDeleted(this.id);

  @override
  List<Object> get props => [id];
}

class RoomLeft extends RoomsEvent {
  final String id;

  RoomLeft(this.id);

  @override
  List<Object> get props => [id];
}
