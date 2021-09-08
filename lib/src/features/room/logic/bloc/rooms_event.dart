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
