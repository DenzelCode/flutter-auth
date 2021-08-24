import 'package:auth/src/features/auth/logic/cubit/auth_cubit.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/auth/views/widgets/authenticated_home.dart';
import 'package:auth/src/features/auth/views/widgets/non_authenticated_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';

  static route() => MaterialPageRoute(builder: (_) => HomeScreen());

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bloc = context.read<AuthCubit>();

    return Scaffold(
      body: FutureBuilder(
        future: bloc.updateProfile(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocBuilder<AuthCubit, User?>(
              buildWhen: (prev, curr) => prev?.id != curr?.id,
              builder: (context, user) {
                return user != null
                    ? AuthenticatedHome(user: user)
                    : NonAuthenticatedHome();
              },
            );
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
