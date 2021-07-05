import 'package:auth/main.dart';
import 'package:auth/src/auth/models/user.dart';
import 'package:auth/src/auth/services/auth_service.dart';
import 'package:auth/src/screens/login_screen.dart';
import 'package:auth/src/screens/register_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = getIt.get<AuthService>();

  User? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: authService.getProfile(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _user = snapshot.data;

            final logged = _user != null;

            return logged
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello, ${_user?.username}!'),
          ElevatedButton(
            onPressed: () async {
              await authService.logout();

              setState(() {
                _user = null;
              });
            },
            child: Text('Logout'),
          )
        ],
      ),
    );
  }
}
