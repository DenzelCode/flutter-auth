import 'package:auth/src/features/room/views/widgets/room_tile.dart';
import 'package:flutter/material.dart';

class RoomsScreen extends StatelessWidget {
  static const String routeName = '/rooms';

  static route() => MaterialPageRoute(builder: (context) => RoomsScreen());

  const RoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _RoomsActions(
            theme: theme,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Your rooms',
            style: theme.textTheme.bodyText1,
          ),
          RoomTile(),
        ],
      ),
    );
  }
}

class _RoomsActions extends StatelessWidget {
  final ThemeData theme;

  const _RoomsActions({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rooms',
              style: theme.textTheme.headline5?.apply(
                fontWeightDelta: 2,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => {},
                  child: Text(
                    'Create Room',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => {},
                  child: Text(
                    'Join Room',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
