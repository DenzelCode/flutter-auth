import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:flutter/material.dart';

class RoomTile extends StatelessWidget {
  final Room room;
  final User user;

  const RoomTile({
    Key? key,
    required this.room,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOwner = room.owner == user.id || room.owner.id == user.id;

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(room.title),
          subtitle: room.owner is String || isOwner
              ? Container()
              : GestureDetector(
                  onTap: () => {},
                  child: Text((room.owner as User).username),
                ),
          trailing: TextButton(
            onPressed: () => {},
            child: Text('Join'),
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => {},
              child: Text(
                'Copy',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            if (isOwner)
              TextButton(
                onPressed: () => {},
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            if (isOwner)
              TextButton(
                onPressed: () => {},
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
