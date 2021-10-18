import 'package:auth/src/features/auth/logic/cubit/auth_cubit.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/notification/logic/repository/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationHandler extends StatefulWidget {
  NotificationHandler({Key? key}) : super(key: key);

  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  @override
  void initState() {
    super.initState();

    if (context.read<AuthCubit>().state != null) {
      notificationRepository.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, User?>(
      listenWhen: (prev, curr) => curr != null,
      listener: (context, state) {
        notificationRepository.requestPermission();
      },
      child: Container(),
    );
  }
}
