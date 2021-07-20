import 'package:auth/src/screens/home_screen.dart';
import 'package:auth/src/screens/login_screen.dart';
import 'package:auth/src/screens/recover_screen.dart';
import 'package:auth/src/screens/register_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> materialKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.materialKey,
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        RecoverScreen.routeName: (context) => RecoverScreen(),
      },
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) => HomeScreen(),
      ),
      theme: ThemeData(
        primaryColor: Color(0xff4C525C),
        accentColor: Color(0xffFFAE48),
        highlightColor: Color(0xff58BFE6),
      ),
    );
  }
}
