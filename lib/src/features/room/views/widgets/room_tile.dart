import 'package:auth/src/constants/environments.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/room/logic/bloc/rooms_bloc.dart';
import 'package:auth/src/features/room/logic/cubit/cubit/room_cubit.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:auth/src/features/room/views/widgets/dialog/upsert_room_dialog.dart';
import 'package:auth/src/shared/views/widgets/dialog/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomTile extends StatelessWidget {
  final Room room;
  final User user;
  final List<Room> memberRooms;

  const RoomTile({
    Key? key,
    required this.room,
    required this.user,
    required this.memberRooms,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOwner = room.owner == user.id || room.owner.id == user.id;

    final isMember = memberRooms.any((e) => e.id == this.room.id);

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text('${room.title} (${room.members.length})'),
          subtitle: room.owner is String || isOwner
              ? Container()
              : GestureDetector(
                  onTap: () => {},
                  child: Text((room.owner as User).username),
                ),
          trailing: TextButton(
            onPressed: () => _join(context),
            child: Text('Join'),
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: _copy,
              child: Text(
                'Copy',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            if (isOwner)
              TextButton(
                onPressed: () => _showUpdateDialog(context),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            if (isOwner)
              TextButton(
                onPressed: () => _showConfirmDeleteDialog(context),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            if (isMember)
              TextButton(
                onPressed: () => _showConfirmLeaveDialog(context),
                child: Text(
                  'Leave',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  _showUpdateDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => UpsertRoomDialog(
        bloc: context.read<RoomsBloc>(),
        room: room,
      ),
    );
  }

  _showConfirmDeleteDialog(BuildContext context) async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialogWidget(),
    );

    if (response != null && response) {
      _delete(context);
    }
  }

  _showConfirmLeaveDialog(BuildContext context) async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialogWidget(),
    );

    if (response != null && response) {
      _leave(context);
    }
  }

  _delete(BuildContext context) {
    context.read<RoomsBloc>().add(RoomDeleted(room.id));
  }

  _leave(BuildContext context) {
    context.read<RoomsBloc>().add(RoomLeft(room.id));
  }

  _copy() {
    Clipboard.setData(
      ClipboardData(text: '${environments.web}/room/${room.id}'),
    );
  }

  _join(BuildContext context) {
    context.read<RoomCubit>().joinRoom(room.id);
  }
}
