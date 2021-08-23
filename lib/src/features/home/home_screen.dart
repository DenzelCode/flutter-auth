import 'package:auth/src/features/auth/models/user.dart';
import 'package:auth/src/features/auth/providers/auth_provider.dart';
import 'package:auth/src/features/auth/widgets/authenticated_home.dart';
import 'package:auth/src/features/auth/widgets/non_authenticated_home.dart';
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
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
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
