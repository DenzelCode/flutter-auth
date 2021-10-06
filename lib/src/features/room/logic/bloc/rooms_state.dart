part of 'rooms_bloc.dart';

abstract class RoomsState extends Equatable {
  const RoomsState();

  @override
  List<Object> get props => [];
}

class RoomsLoadInProgressState extends RoomsState {}

class RoomsLoadFailureState extends RoomsState {}

class RoomsLoadSuccessState extends RoomsState {
  final List<Room> userRooms;
  final List<Room> publicRooms;
  final List<Room> memberRooms;

  RoomsLoadSuccessState({
    this.userRooms = const [],
    this.publicRooms = const [],
    this.memberRooms = const [],
  });

  @override
  List<Object> get props => [userRooms, publicRooms, memberRooms];
}
