import 'package:auth/src/app.dart';
import 'package:auth/src/constants/environments.dart';
import 'package:auth/src/features/auth/logic/repository/auth_repository.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocketConnection {
  static Socket socket = io(
    environments.socket,
    OptionBuilder().disableAutoConnect().setExtraHeaders({}).build(),
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
