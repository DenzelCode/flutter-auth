import 'package:flutter/material.dart';

class RoomTile extends StatelessWidget {
  const RoomTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text('Room title'),
          subtitle: GestureDetector(
            onTap: () => {},
            child: Text('Room owner'),
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
            TextButton(
              onPressed: () => {},
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () => {},
              child: Text(
                'Copy',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
