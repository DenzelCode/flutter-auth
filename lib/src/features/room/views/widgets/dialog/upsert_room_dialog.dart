import 'package:auth/src/features/room/logic/bloc/rooms_bloc.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpsertRoomDialog extends StatefulWidget {
  final Room? room;
  final RoomsBloc bloc;

  UpsertRoomDialog({Key? key, this.room, required this.bloc}) : super(key: key);

  @override
  _UpsertRoomDialogState createState() => _UpsertRoomDialogState();
}

class _UpsertRoomDialogState extends State<UpsertRoomDialog> {
  String _title = '';
  bool _isPublic = false;

  @override
  void initState() {
    super.initState();

    if (widget.room != null) {
      _title = widget.room!.title;
      _isPublic = widget.room!.isPublic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.room == null
          ? 'Create Room'
          : 'Update Room ${widget.room?.title}'),
      content: Form(
        child: BlocBuilder(
          bloc: widget.bloc,
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocListener(
                  bloc: widget.bloc,
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
    if (widget.room == null) {
      widget.bloc.add(RoomCreatedEvent(title: _title, isPublic: _isPublic));

      return;
    }

    widget.bloc.add(RoomUpdatedEvent(
      id: widget.room?.id as String,
      title: _title,
      isPublic: _isPublic,
    ));
  }
}
