import 'package:flutter/material.dart';

class GoBack extends StatelessWidget {
  const GoBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(0, 0),
      ),
      onPressed: () => Navigator.pop(context),
      child: Icon(
        Icons.chevron_left_sharp,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
