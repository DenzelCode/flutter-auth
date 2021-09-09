import 'package:flutter/material.dart';

class ConfirmDialogWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final String? closeText;
  final String? acceptText;

  ConfirmDialogWidget({
    Key? key,
    this.title,
    this.description,
    this.closeText,
    this.acceptText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? 'Are you sure?'),
      content: Text(
          description ?? 'You are not going to be able to undo this action'),
      actions: [
        TextButton(
          child: Text(closeText ?? 'Close'),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Text(acceptText ?? 'Accept'),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
