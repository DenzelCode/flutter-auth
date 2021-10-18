import 'package:auth/src/features/messages/logic/bloc/direct_message_bloc.dart';
import 'package:auth/src/features/messages/logic/bloc/message_bloc.dart';
import 'package:auth/src/features/messages/logic/enum/message_type.dart';
import 'package:auth/src/features/messages/views/widgets/messages.dart';
import 'package:auth/src/shared/views/widgets/user_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DirectMessageArguments {
  final String username;
  final bool fromMessages;

  DirectMessageArguments({
    required this.username,
    this.fromMessages = false,
  });
}

class DirectMessageScreen extends StatefulWidget {
  static const routeName = '/direct-message';

  static Route route(RouteSettings settings) {
    final args = settings.arguments as DirectMessageArguments;

    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => DirectMessageBloc(
          args.username,
          fromMessages: args.fromMessages,
        ),
        child: DirectMessageScreen(fromMessages: args.fromMessages),
      ),
    );
  }

  final bool fromMessages;

  DirectMessageScreen({Key? key, required this.fromMessages}) : super(key: key);

  @override
  _DirectMessageScreenState createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  @override
  void initState() {
    super.initState();

    context.read<DirectMessageBloc>().add(UserLoadedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DirectMessageBloc, DirectMessageState>(
      builder: (context, state) {
        if (state is SocketConnectState) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(state.user.username),
                  UserStatus(
                    online: state.user.online,
                  ),
                ],
              ),
            ),
            body: BlocProvider(
              create: (context) => MessageBloc(
                partnerId: state.user.id,
                type: MessageType.direct,
                context: context,
                fromMessages: widget.fromMessages,
              ),
              child: Builder(
                builder: (context) => Messages(
                  type: MessageType.direct,
                  bloc: context.read<MessageBloc>(),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
