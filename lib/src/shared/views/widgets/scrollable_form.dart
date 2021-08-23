import 'package:flutter/material.dart';

class ScrollableForm extends StatelessWidget {
  final List<Widget> children;

  final EdgeInsetsGeometry? padding;

  const ScrollableForm({
    Key? key,
    required this.children,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Form(
        child: Container(
          padding: padding,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: children,
          ),
        ),
      ),
    );
  }
}
