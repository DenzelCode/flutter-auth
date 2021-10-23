import 'package:auth/src/app_router.dart';
import 'package:auth/src/features/auth/logic/cubit/auth_cubit.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/auth/logic/repository/auth_repository.dart';
import 'package:auth/src/features/home/views/screens/home_screen.dart';
import 'package:auth/src/features/notification/logic/repository/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> applicationKey = GlobalKey();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appRouter = AppRouter();

  @override
  void initState() {
    super.initState();

    notificationRepository.init();
  }

  @override
  Widget build(BuildContext context) {
    return _InitProviders(
      child: MaterialApp(
        navigatorKey: applicationKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        initialRoute: HomeScreen.routeName,
        onGenerateRoute: appRouter.onGenerateRoute,
        theme: ThemeData(
          primaryColor: Color(0xff4C525C),
          secondaryHeaderColor: Color(0xffFFAE48),
          highlightColor: Color(0xff58BFE6),
        ),
      ),
    );
  }
}

class _InitProviders extends StatelessWidget {
  final Widget child;

  const _InitProviders({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: BlocListener<AuthCubit, User?>(
          listenWhen: (prev, curr) => prev != null && curr == null,
          listener: (context, user) {
            final route = ModalRoute.of(context)?.settings.name;

            if (user == null && route != HomeScreen.routeName) {
              Navigator.pushNamedAndRemoveUntil(
                applicationKey.currentContext as BuildContext,
                HomeScreen.routeName,
                (route) => false,
              );
            }
          },
          child: child,
        ),
      ),
    );
  }
}
