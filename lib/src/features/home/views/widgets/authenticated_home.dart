import 'package:auth/src/features/auth/logic/cubit/auth_cubit.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/room/views/screens/rooms_screen.dart';
import 'package:auth/src/shared/views/widgets/circles_background.dart';
import 'package:auth/src/shared/views/widgets/underlined_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticatedHome extends StatelessWidget {
  final User user;

  AuthenticatedHome({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CirclesBackground(
      backgroundColor: Colors.white,
      topSmallCircleColor: theme.secondaryHeaderColor,
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
                  '(${user.email})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.highlightColor,
                  ),
                ),
                Row(
                  children: [
                    UnderlinedButton(
                      child: Text('Logout'),
                      color: theme.secondaryHeaderColor,
                      onPressed: () => context.read<AuthCubit>().logout(),
                    ),
                    UnderlinedButton(
                      child: Text('Rooms'),
                      color: theme.highlightColor,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RoomsScreen.routeName,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Spacer(),
                UnderlinedButton(
                  child: Text('Logout'),
                  color: theme.highlightColor,
                  onPressed: () => context.read<AuthCubit>().logout(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
