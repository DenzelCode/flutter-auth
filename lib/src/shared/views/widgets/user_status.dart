import 'package:flutter/material.dart';

class UserStatus extends StatelessWidget {
  final bool online;

  const UserStatus({Key? key, required this.online}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: online ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
