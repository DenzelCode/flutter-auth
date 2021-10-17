part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class MessagesLoadedEvent extends MessageEvent {}

class PreviousMessagesLoadedEvent extends MessageEvent {
  final double previousScrollHeight;

  PreviousMessagesLoadedEvent(this.previousScrollHeight);
}

class MessageSentEvent extends MessageEvent {
  final String message;

  MessageSentEvent(this.message) : super();

  @override
  List<Object> get props => [message];
}

abstract class MessageObjectEvent extends MessageEvent {
  final Message message;

  MessageObjectEvent(this.message) : super();

  @override
  List<Object> get props => [message];
}

class MessageDeletedEvent extends MessageEvent {
  final String messageId;

  MessageDeletedEvent(this.messageId) : super();

  @override
  List<Object> get props => [messageId];
}

class MessageDeletedRequestEvent extends MessageEvent {
  final Message message;

  MessageDeletedRequestEvent(this.message) : super();

  @override
  List<Object> get props => [message];
}

class MessagesDeletedEvent extends MessageEvent {}

class TypingRemovedEvent extends MessageEvent {
  final User user;

  TypingRemovedEvent(this.user);
}

class MessageReceivedEvent extends MessageObjectEvent {
  MessageReceivedEvent(Message message) : super(message);
}

class MessageUserTypedEvent extends MessageEvent {
  final Typing typing;

  MessageUserTypedEvent(this.typing) : super();

  @override
  List<Object> get props => [typing];
}
