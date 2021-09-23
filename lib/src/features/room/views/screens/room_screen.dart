import 'package:auth/src/features/room/logic/cubit/cubit/room_cubit.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:auth/src/features/room/logic/repository/room_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomScreen extends StatefulWidget {
  static const routeName = '/room';

  static route(RouteSettings settings) {
    final roomId = settings.arguments as String;

    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) =>
            RoomCubit(repository: RoomRepository())..joinRoom(roomId),
        child: RoomScreen(roomId: roomId),
      ),
    );
  }

  final String roomId;

  const RoomScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late Room room;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoomCubit, RoomState>(
      listener: (_, state) => Navigator.pop(context),
      listenWhen: (_, curr) => curr is RoomJoinFailure,
      builder: (_, state) {
        if (state is RoomJoinSuccess) {
          return Scaffold(
            appBar: AppBar(title: Text(state.room.title)),
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
