part of 'rooms_bloc.dart';

abstract class RoomsState extends Equatable {
  const RoomsState();

  @override
  List<Object> get props => [];
}

class RoomsLoadInProgress extends RoomsState {}

class RoomsLoadFailure extends RoomsState {}

class RoomsLoadSuccess extends RoomsState {
  final List<Room> userRooms;
  final List<Room> publicRooms;
  final List<Room> memberRooms;

  RoomsLoadSuccess({
    this.userRooms = const [],
    this.publicRooms = const [],
    this.memberRooms = const [],
  });

  @override
  List<Object> get props => [userRooms, publicRooms, memberRooms];
}
