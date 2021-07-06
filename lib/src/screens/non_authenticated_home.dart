import 'package:auth/src/common/widgets/circles_background.dart';
import 'package:auth/src/common/widgets/underlined_button.dart';
import 'package:auth/src/screens/login_screen.dart';
import 'package:auth/src/screens/register_screen.dart';
import 'package:flutter/material.dart';

class NonAuthenticatedHome extends StatelessWidget {
  const NonAuthenticatedHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CirclesBackground(
      backgroundColor: Colors.white,
      topSmallCircleColor: theme.accentColor,
      topMediumCircleColor: theme.primaryColor,
      topRightCircleColor: Colors.white,
      bottomRightCircleColor: theme.highlightColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: Text(
                'Authentication Application',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            Row(
              children: [
                Text(
                  'by ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  'Denzel Code',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.highlightColor,
                    fontSize: 30,
                  ),
                )
              ],
            ),
            Spacer(),
            Row(
              children: [
                UnderlinedButton(
                  child: Text('Sign In'),
                  color: theme.accentColor,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    LoginScreen.routeName,
                  ),
                ),
                Spacer(),
                UnderlinedButton(
                  child: Text('Sign Up'),
                  color: theme.highlightColor,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RegisterScreen.routeName,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
