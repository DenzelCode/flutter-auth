import 'package:flutter/material.dart';

class UnderlinedButton extends StatelessWidget {
  final Widget child;

  final VoidCallback? onPressed;

  final Color color;

  final Color? textColor;

  const UnderlinedButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.textColor,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              color: color,
              height: 10,
              width: 500,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: child,
          )
        ],
      ),
      style: TextButton.styleFrom(
        primary: textColor ?? Colors.black,
        textStyle: TextStyle(
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}
