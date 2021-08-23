import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final bool? loading;

  const NextButton({Key? key, this.onPressed, this.loading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        color: Colors.white,
        onPressed: onPressed,
        icon: loading == true
            ? CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Icon(Icons.arrow_forward),
      ),
    );
  }
}
