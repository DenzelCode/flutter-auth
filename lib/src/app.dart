import 'package:auth/src/features/auth/logic/cubit/auth_cubit.dart';
import 'package:auth/src/features/auth/logic/repository/auth_repository.dart';
import 'package:auth/src/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> materialKey = GlobalKey();

  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: MaterialApp(
          navigatorKey: MyApp.materialKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) => HomeScreen.route,
          theme: ThemeData(
            primaryColor: Color(0xff4C525C),
            accentColor: Color(0xffFFAE48),
            highlightColor: Color(0xff58BFE6),
          ),
        ),
      ),
    );
  }
}
