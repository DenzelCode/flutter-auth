import 'package:auth/src/core/socket.dart';
import 'package:auth/src/features/messages/logic/enum/message_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final String partner;

  final MessageType type;

  final Socket socket = socketManager.socket;

  MessageBloc({
    required this.partner,
    required this.type,
  }) : super(MessageInitial()) {
    initEvents();

    initSockets();
  }

  void initEvents() {
    on<MessageEvent>((event, emit) {});
  }

  void initSockets() {
    socket.on('message:${type.name}', (data) {});

    socket.on('${type.name}:delete_messages', (data) {});

    socket.on('${type.name}:delete_message', (data) {});

    socket.on('message:${type.name}:typing', (data) {});
  }
}
