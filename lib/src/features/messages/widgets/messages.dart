import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:flutter/widgets.dart';

enum MessageType { room, direct }

class Messages extends StatefulWidget {
  Room? room;
  User? to;
  MessageType type;

  Messages({
    Key? key,
    this.room,
    this.to,
    required this.type,
  }) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
