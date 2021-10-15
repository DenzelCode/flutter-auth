import 'package:auth/src/features/auth/logic/cubit/auth_cubit.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/room/logic/bloc/room_bloc.dart';
import 'package:auth/src/features/room/logic/bloc/rooms_bloc.dart';
import 'package:auth/src/features/room/logic/repository/room_repository.dart';
import 'package:auth/src/features/room/views/screens/room_screen.dart';
import 'package:auth/src/features/room/views/widgets/dialog/join_room_dialog.dart';
import 'package:auth/src/features/room/views/widgets/room_tile.dart';
import 'package:auth/src/features/room/views/widgets/dialog/upsert_room_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomsScreen extends StatelessWidget {
  static const String routeName = '/rooms';

  static route() {
    return MaterialPageRoute(builder: (context) {
      final repository = RoomRepository();

      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => RoomsBloc(
              repository: repository,
            )..add(RoomsLoadedEvent()),
          ),
          BlocProvider(
            create: (_) => RoomBloc(),
          )
        ],
        child: RoomsScreen(),
      );
    });
  }

  RoomsScreen({Key? key}) : super(key: key);

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
          body: RefreshIndicator(
            onRefresh: () async =>
                context.read<RoomsBloc>().add(RoomsLoadedEvent()),
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                _RoomsActions(
                  theme: theme,
                ),
                SizedBox(
                  height: 16,
                ),
                BlocListener<RoomBloc, RoomState>(
                  listenWhen: (_, curr) =>
                      curr is RoomCheckSuccessState && !curr.isDialog,
                  listener: (context, state) {
                    Navigator.pushNamed(
                      context,
                      RoomScreen.routeName,
                      arguments: (state as RoomCheckSuccessState).room.id,
                    );
                  },
                  child: Container(),
                ),
                BlocBuilder<RoomsBloc, RoomsState>(
                  builder: (context, state) {
                    if (state is RoomsLoadInProgressState) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: theme.primaryColor,
                        ),
                      );
                    }

                    if (!(state is RoomsLoadSuccessState)) {
                      return Container();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Rooms',
                          style: theme.textTheme.bodyText1,
                        ),
                        ...state.userRooms.map(
                          (room) => Column(
                            children: [
                              RoomTile(
                                user: user,
                                room: room,
                                memberRooms: state.memberRooms,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Joined Rooms',
                          style: theme.textTheme.bodyText1,
                        ),
                        ...state.memberRooms.map(
                          (room) => Column(
                            children: [
                              RoomTile(
                                user: user,
                                room: room,
                                memberRooms: state.memberRooms,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Public Rooms',
                          style: theme.textTheme.bodyText1,
                        ),
                        ...state.publicRooms.map(
                          (room) => Column(
                            children: [
                              RoomTile(
                                user: user,
                                room: room,
                                memberRooms: state.memberRooms,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
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
    return BlocBuilder<RoomsBloc, RoomsState>(
      builder: (context, state) {
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
                      onPressed: () => _showCreateDialog(context),
                      child: Text(
                        'Create Room',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showJoinDialog(context),
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
      },
    );
  }

  _showCreateDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => UpsertRoomDialog(bloc: context.read<RoomsBloc>()),
    );
  }

  _showJoinDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => JoinRoomDialog(bloc: context.read<RoomBloc>()),
    );
  }
}
