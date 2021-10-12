import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/messages/widgets/messages.dart';
import 'package:auth/src/features/room/logic/bloc/room_bloc.dart';
import 'package:auth/src/features/room/logic/repository/room_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomScreen extends StatefulWidget {
  static const routeName = '/room';

  static route(RouteSettings settings) {
    final roomId = settings.arguments as String;

    return MaterialPageRoute(builder: (_) {
      final bloc = RoomBloc(
        repository: RoomRepository(),
      );

      return BlocProvider(
        create: (_) => bloc,
        child: RoomScreen(roomId: roomId),
      );
    });
  }

  final String roomId;

  const RoomScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  bool _showMembers = false;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<RoomBloc>();

    bloc.add(RoomJoinedEvent(widget.roomId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoomBloc, RoomState>(
      listener: (_, state) => Navigator.pop(context),
      listenWhen: (_, curr) =>
          curr is RoomJoinFailureState ||
          curr is RoomCheckFailureState ||
          curr is DirectRooomDeleteState,
      builder: (_, state) {
        if (state is RoomJoinSuccessState) {
          final room = state.room;

          return Scaffold(
            appBar: AppBar(
              title: Text(room.title),
              actions: [
                IconButton(
                  onPressed: () => setState(() {
                    _showMembers = !_showMembers;
                  }),
                  icon: Icon(Icons.menu),
                ),
              ],
            ),
            body: _showMembers
                ? _RoomMembers(
                    members: room.members as List<User>,
                  )
                : Messages(
                    type: MessageType.room,
                    room: room,
                  ),
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class _RoomMembers extends StatefulWidget {
  final List<User> members;

  _RoomMembers({Key? key, required this.members}) : super(key: key);

  @override
  _RoomMembersState createState() => _RoomMembersState();
}

class _RoomMembersState extends State<_RoomMembers> {
  bool _showOnlineUsers = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(_showOnlineUsers ? 'Online Members' : 'All Members'),
          value: _showOnlineUsers,
          onChanged: (value) =>
              setState(() => _showOnlineUsers = !_showOnlineUsers),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (_, index) {
              final member = widget.members[index];

              if (_showOnlineUsers && !member.online) {
                return Container();
              }

              return ListTile(
                title: Text(member.username),
              );
            },
            itemCount: widget.members.length,
          ),
        )
      ],
    );
  }
}
