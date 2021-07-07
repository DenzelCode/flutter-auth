import 'package:flutter/material.dart';

class ScrollCloseKeyboard extends StatelessWidget {
  final Widget child;

  const ScrollCloseKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.distance > 20) {
          FocusScope.of(context).unfocus();
        }
      },
      child: child,
    );
  }
}
