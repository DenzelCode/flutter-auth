import 'package:auth/src/app_router.dart';
import 'package:auth/src/features/home/home_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> materialKey = GlobalKey();

  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.materialKey,
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: _appRouter.onGenerateRoute,
      theme: ThemeData(
        primaryColor: Color(0xff4C525C),
        accentColor: Color(0xffFFAE48),
        highlightColor: Color(0xff58BFE6),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _appRouter.dispose();
  }
}
