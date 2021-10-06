import 'package:auth/src/core/socket.dart';
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
      listenWhen: (_, curr) => curr is RoomJoinFailureState,
      builder: (_, state) {
        if (state is RoomJoinSuccessState) {
          final room = state.room;

          return Scaffold(
            appBar: AppBar(
              title: Text(room.title),
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
