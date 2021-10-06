import 'package:auth/src/features/room/logic/bloc/room_bloc.dart';
import 'package:auth/src/features/room/views/screens/room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinRoomDialog extends StatefulWidget {
  final RoomBloc bloc;

  JoinRoomDialog({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  _JoinRoomDialogState createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  String _roomId = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Join Room'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocListener(
            listenWhen: (prev, curr) =>
                prev != curr && curr is RoomCheckSuccessState && curr.isDialog,
            listener: (context, state) {
              Navigator.pop(context);

              Navigator.pushNamed(
                context,
                RoomScreen.routeName,
                arguments: (state as RoomCheckSuccessState).room.id,
              );
            },
            bloc: widget.bloc,
            child: Container(),
          ),
          Form(
            child: TextFormField(
              initialValue: _roomId,
              decoration: InputDecoration(hintText: 'Code'),
              onChanged: (value) => setState(() => _roomId = value),
              autofocus: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _join(),
          child: Text('Save'),
        ),
      ],
    );
  }

  _join() {
    final id = _roomId.trim();

    if (id.isEmpty) {
      return;
    }

    widget.bloc.add(RoomCheckedEvent(id.split('/').last, isDialog: true));
  }
}
