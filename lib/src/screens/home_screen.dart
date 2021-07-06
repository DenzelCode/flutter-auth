import 'package:auth/main.dart';
import 'package:auth/src/auth/models/user.dart';
import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/common/widgets/circles_background.dart';
import 'package:auth/src/common/widgets/underlined_button.dart';
import 'package:auth/src/screens/authenticated_home.dart';
import 'package:auth/src/screens/login_screen.dart';
import 'package:auth/src/screens/register_screen.dart';
import 'package:auth/src/screens/non_authenticated_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder(
        future: provider.getProfile(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final user = provider.user;

            return user != null ? AuthenticatedHome() : NonAuthenticatedHome();
          }

          return Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          );
        },
      ),
    );
  }
}
