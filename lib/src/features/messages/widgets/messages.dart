import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum MessageType { room, direct }

class Messages extends StatefulWidget {
  final Room? room;
  final User? to;
  final MessageType type;

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
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, i) {
              return Column(
                children: [
                  if (i == 0)
                    SizedBox(
                      height: 10,
                    ),
                  Container(
                    color: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Testing this shit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
            itemCount: 5,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
