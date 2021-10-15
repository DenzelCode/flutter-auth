part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

abstract class MessagesState extends MessageState {
  final List<Message> messages;

  MessagesState(this.messages) : super();

  @override
  List<Object> get props => [messages];
}

class MessagesLoadInProgressState extends MessageState {}

class MessagesLoadSuccessState extends MessagesState {
  MessagesLoadSuccessState(List<Message> messages) : super(messages);
}

class MessagesLoadFailureState extends MessageState {}

class MessageReceiveState extends MessagesState {
  MessageReceiveState(List<Message> messages) : super(messages);
}

class PreviousMessagesLoadState extends MessagesState {
  final double previousScrollHeight;

  PreviousMessagesLoadState(List<Message> messages, this.previousScrollHeight)
      : super(messages);
}
