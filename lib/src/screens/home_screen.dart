import 'package:auth/main.dart';
import 'package:auth/src/auth/models/user.dart';
import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/screens/login_screen.dart';
import 'package:auth/src/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: FutureBuilder(
        future: provider.getProfile(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final user = provider.user;

            return user != null
                ? _authenticated(context)
                : _notAuthenticated(context);
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _notAuthenticated(BuildContext context) {
    return Center(
      child: Center(
        child: Row(
          children: [
            Spacer(),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, LoginScreen.routeName),
              child: Text('Login'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RegisterScreen.routeName),
              child: Text('Register'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _authenticated(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    final user = provider.user;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello, ${user?.username}!'),
          ElevatedButton(
            onPressed: () async {
              await provider.logout();
            },
            child: Text('Logout'),
          )
        ],
      ),
    );
  }
}
