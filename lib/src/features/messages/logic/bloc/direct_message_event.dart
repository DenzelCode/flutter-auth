part of 'direct_message_bloc.dart';

abstract class DirectMessageEvent extends Equatable {
  const DirectMessageEvent();

  @override
  List<Object> get props => [];
}

class UserLoadedEvent extends DirectMessageEvent {}

class SocketDisconnectedEvent extends DirectMessageEvent {}

class SocketConnectedEvent extends DirectMessageEvent {}
