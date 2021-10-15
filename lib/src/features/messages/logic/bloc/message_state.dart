part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}
