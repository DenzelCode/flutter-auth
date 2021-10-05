import 'package:auth/src/app.dart';
import 'package:auth/src/constants/environments.dart';
import 'package:auth/src/features/auth/logic/repository/auth_repository.dart';
import 'package:auth/src/shared/views/widgets/dialog/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocketConnection {
  static Socket socket = io(
    environments.socket,
    OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setExtraHeaders({})
        .build(),
  );

  static Future<Socket> init() async {
    if (socket.connected) {
      return socket;
    }

    final context = MyApp.materialKey.currentContext;

    final repository = context?.read<AuthRepository>();

    if (repository == null) {
      return socket;
    }

    final accessToken = await repository.getAccessToken();

    socket.io.options['extraHeaders'] = {
      'Authorization': 'Bearer $accessToken'
    };

    print('pwewererwefge');

    socket.onError((error) {
      if (context == null) {
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          title: error['error'] ?? error['message'],
          description: error['message'],
        ),
      );
    });

    socket.onConnect((_) => socket.emit('user:subscribe'));

    socket.onDisconnect((reason) async {
      if (reason != 'io server disconnect') {
        return;
      }

      await repository.loginWithRefreshToken();

      init();
    });

    return socket.connect();
  }

  static void dispose() {
    socket.dispose();
  }
}
