import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final String title;
  final dynamic description;
  final String? closeText;

  AlertWidget({
    Key? key,
    required this.title,
    required this.description,
    this.closeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: description is List
                ? (description as List).map((text) => Text(text)).toList()
                : [Text(description)],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(closeText ?? 'Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
