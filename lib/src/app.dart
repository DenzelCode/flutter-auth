import 'package:auth/src/common/widgets/circles_background.dart';
import 'package:auth/src/screens/home_screen.dart';
import 'package:auth/src/screens/login_screen.dart';
import 'package:auth/src/screens/register_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
      },
      theme: ThemeData(
        primaryColor: Color(0xff8A4C7D),
        accentColor: Color(0xffFD969C),
        highlightColor: Color(0xffE4DB7C),
      ),
    );
  }
}
