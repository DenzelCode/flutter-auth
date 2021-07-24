import 'package:auth/src/screens/home_screen.dart';
import 'package:flutter/material.dart';

class GoBack extends StatelessWidget {
  const GoBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onTap = () async {
      if (!await Navigator.maybePop(context)) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (_) => false,
        );
      }
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
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
      ),
    );
  }
}
