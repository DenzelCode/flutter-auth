part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

abstract class MessagesState extends MessageState {
  final List<User> usersTyping;

  final List<Message> messages;

  MessagesState(this.messages, [this.usersTyping = const []]) : super();

  @override
  List<Object> get props => [messages, usersTyping];
}

class MessagesLoadInProgressState extends MessageState {}

class MessagesLoadSuccessState extends MessagesState {
  MessagesLoadSuccessState(List<Message> messages) : super(messages);
}

class MessagesLoadFailureState extends MessageState {}

class MessageReceiveState extends MessagesState {
  MessageReceiveState(List<Message> messages,
      [List<User> usersTyping = const []])
      : super(messages, usersTyping);
}

class MessageDeleteState extends MessagesState {
  MessageDeleteState(List<Message> messages,
      [List<User> usersTyping = const []])
      : super(messages, usersTyping);
}

class MessageTypingState extends MessagesState {
  MessageTypingState(List<Message> messages,
      [List<User> usersTyping = const []])
      : super(messages, usersTyping);
}

class PreviousMessagesLoadState extends MessagesState {
  final double previousScrollHeight;

  PreviousMessagesLoadState(List<Message> messages, this.previousScrollHeight,
      [List<User> usersTyping = const []])
      : super(messages, usersTyping);
}
