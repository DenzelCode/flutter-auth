import 'package:auth/src/features/auth/logic/cubit/auth_cubit.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/room/views/widgets/room_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomsScreen extends StatefulWidget {
  static const String routeName = '/rooms';

  static route() => MaterialPageRoute(builder: (context) => RoomsScreen());

  RoomsScreen({Key? key}) : super(key: key);

  @override
  RoomsScreenState createState() => RoomsScreenState();
}

class RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthCubit, User?>(
      builder: (context, user) {
        if (user == null) {
          return Container();
        }

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
              Divider(),
            ],
          ),
        );
      },
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
