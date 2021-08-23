import 'dart:math';

import 'package:auth/src/features/auth/views/screens/login_screen.dart';
import 'package:auth/src/features/auth/views/screens/register_screen.dart';
import 'package:auth/src/features/home/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }

  void dispose() {}
}
