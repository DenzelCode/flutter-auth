import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/common/widgets/circles_background.dart';
import 'package:auth/src/common/widgets/underlined_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticatedHome extends StatelessWidget {
  const AuthenticatedHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    final user = provider.user;

    final theme = Theme.of(context);

    if (user == null) {
      return Container();
    }

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authenticated as ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  user.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.highlightColor,
                    fontSize: 30,
                  ),
                ),
                Text(
                  ' (${user.email})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.highlightColor,
                  ),
                ),
                UnderlinedButton(
                  child: Text('Logout'),
                  color: theme.accentColor,
                  onPressed: () => provider.logout(),
                )
              ],
            ),
            Spacer(),
            Row(
              children: [
                Spacer(),
                UnderlinedButton(
                  child: Text('Logout'),
                  color: theme.highlightColor,
                  onPressed: () => provider.logout(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
