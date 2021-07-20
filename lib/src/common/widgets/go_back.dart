import 'package:flutter/material.dart';

class GoBack extends StatelessWidget {
  const GoBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Column(
        children: [
          Transform.scale(
            scale: 2,
            child: Icon(
              Icons.chevron_left_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
