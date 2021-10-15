part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class MessageSentEvent extends MessageEvent {
  final String message;

  MessageSentEvent(this.message) : super();

  @override
  List<Object> get props => [message];
}
