import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/messages/logic/bloc/message_bloc.dart';
import 'package:auth/src/features/messages/logic/enum/message_type.dart';
import 'package:auth/src/features/messages/views/screens/direct_message_screen.dart';
import 'package:auth/src/features/messages/views/widgets/messages.dart';
import 'package:auth/src/features/room/logic/bloc/room_bloc.dart';
import 'package:auth/src/shared/views/widgets/user_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomScreen extends StatefulWidget {
  static const routeName = '/room';

  static route(RouteSettings settings) {
    final roomId = settings.arguments as String;

    return MaterialPageRoute(builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RoomBloc()),
          BlocProvider(
            create: (context) => MessageBloc(
              partnerId: roomId,
              type: MessageType.room,
              context: context,
            ),
          ),
        ],
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
        if (state is SocketConnectState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.room.title),
              actions: [
                IconButton(
                  onPressed: () => setState(() {
                    _showMembers = !_showMembers;
                  }),
                  icon: Icon(Icons.menu),
                ),
              ],
            ),
            body: Stack(
              children: [
                Messages(
                  type: MessageType.room,
                  room: state.room,
                  bloc: context.read<MessageBloc>(),
                ),
                if (_showMembers) _RoomMembers(members: state.room.members)
              ],
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
  final List<dynamic> members;

  _RoomMembers({Key? key, required this.members}) : super(key: key);

  @override
  _RoomMembersState createState() => _RoomMembersState();
}

class _RoomMembersState extends State<_RoomMembers> {
  bool _showOnlineUsers = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
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
                final member = widget.members[index] as User;

                if (_showOnlineUsers && !member.online) {
                  return Container();
                }

                return MaterialButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    DirectMessageScreen.routeName,
                    arguments: DirectMessageArguments(
                      username: member.username,
                      fromMessages: true,
                    ),
                  ),
                  child: ListTile(
                    title: Text(member.username),
                    trailing: UserStatus(online: member.online),
                  ),
                );
              },
              itemCount: widget.members.length,
            ),
          )
        ],
      ),
    );
  }
}
