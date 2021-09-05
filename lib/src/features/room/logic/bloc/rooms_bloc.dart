import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  RoomsBloc() : super(RoomsInitial());

  @override
  Stream<RoomsState> mapEventToState(
    RoomsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
