part of 'direct_message_bloc.dart';

abstract class DirectMessageState extends Equatable {
  const DirectMessageState();

  @override
  List<Object> get props => [];
}

class DirectMessageInitialState extends DirectMessageState {}

class UserLoadInProgressState extends DirectMessageState {}

class UserLoadFailureState extends DirectMessageState {}

abstract class DirectUserState extends DirectMessageState {
  final User user;

  DirectUserState(this.user) : super();

  @override
  List<Object> get props => [user];
}

class UserLoadSuccessState extends DirectUserState {
  UserLoadSuccessState(User user) : super(user);
}

class SocketConnectState extends DirectUserState {
  SocketConnectState(User user) : super(user);
}

class SocketDisconnectState extends DirectUserState {
  SocketDisconnectState(User user) : super(user);
}
