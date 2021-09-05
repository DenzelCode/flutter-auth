part of 'rooms_bloc.dart';

abstract class RoomsState extends Equatable {
  const RoomsState();
  
  @override
  List<Object> get props => [];
}

class RoomsInitial extends RoomsState {}
