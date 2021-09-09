import 'package:auth/src/features/room/logic/bloc/rooms_bloc.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpsertRoomDialog extends StatefulWidget {
  final Room? room;
  final RoomsBloc bloc;

  UpsertRoomDialog({Key? key, this.room, required this.bloc}) : super(key: key);

  @override
  _UpsertRoomDialogState createState() =>
      _UpsertRoomDialogState(room: room, bloc: bloc);
}

class _UpsertRoomDialogState extends State<UpsertRoomDialog> {
  final Room? room;
  final RoomsBloc bloc;

  String _title = '';
  bool _isPublic = false;

  _UpsertRoomDialogState({this.room, required this.bloc});

  @override
  void initState() {
    super.initState();

    if (room != null) {
      _title = room!.title;
      _isPublic = room!.isPublic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(room == null ? 'Create Room' : 'Update Room ${room?.title}'),
      content: Form(
        child: BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocListener(
                  bloc: bloc,
                  listenWhen: (prev, curr) => prev != curr,
                  listener: (context, state) => Navigator.pop(context),
                  child: Container(),
                ),
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(hintText: 'Title'),
                  onChanged: (value) => setState(() => _title = value),
                  autofocus: true,
                ),
                SwitchListTile(
                  title: Text('Public'),
                  value: _isPublic,
                  onChanged: (value) => setState(() => _isPublic = value),
                )
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _save(context),
          child: Text('Save'),
        ),
      ],
    );
  }

  _save(BuildContext context) {
    if (room == null) {
      bloc.add(RoomCreated(title: _title, isPublic: _isPublic));

      return;
    }

    bloc.add(RoomUpdated(
      id: room?.id as String,
      title: _title,
      isPublic: _isPublic,
    ));
  }
}
