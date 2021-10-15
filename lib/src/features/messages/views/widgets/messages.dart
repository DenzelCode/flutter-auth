import 'package:auth/src/features/auth/logic/cubit/auth_cubit.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/messages/logic/bloc/message_bloc.dart';
import 'package:auth/src/features/messages/logic/enum/message_type.dart';
import 'package:auth/src/features/messages/logic/models/message.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Messages extends StatefulWidget {
  final Room? room;
  final User? to;
  final MessageType type;
  final MessageBloc bloc;

  Messages({
    Key? key,
    this.room,
    this.to,
    required this.type,
    required this.bloc,
  }) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _scrollController = ScrollController();

  final _showMoreOffset = 0;

  final _scrollToLastOffset = 0;

  @override
  void initState() {
    super.initState();

    widget.bloc.add(MessagesLoadedEvent());

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is PreviousMessagesLoadState) {
          SchedulerBinding.instance?.addPostFrameCallback(
            (_) => _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent -
                  state.previousScrollHeight,
            ),
          );
        }

        if (state is MessagesLoadSuccessState) {
          SchedulerBinding.instance?.addPostFrameCallback(
            (_) => _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            ),
          );
        }

        if (state is MessageReceiveState) {
          if (_scrollController.offset >
              _scrollController.position.maxScrollExtent -
                  _scrollToLastOffset) {
            SchedulerBinding.instance?.addPostFrameCallback(
              (_) => _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
              ),
            );
          }
        }
      },
      child: Column(
        children: [
          Expanded(
            child: _Messages(scrollController: _scrollController),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(color: Colors.white),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Message'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.offset <= _showMoreOffset) {
      widget.bloc.add(
        PreviousMessagesLoadedEvent(_scrollController.position.maxScrollExtent),
      );
    }
  }
}

class _Messages extends StatelessWidget {
  final ScrollController scrollController;

  const _Messages({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        if (state is MessagesLoadInProgressState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!(state is MessagesState)) {
          return Container();
        }

        return BlocBuilder<AuthCubit, User?>(
          builder: (context, user) {
            if (user == null) {
              return Container();
            }

            return ListView.builder(
              controller: scrollController,
              itemCount: state.messages.length,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemBuilder: (context, i) {
                final message = state.messages[i];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (i == 0)
                        SizedBox(
                          height: 20,
                        ),
                      _Message(
                        message: message,
                        currentUser: user,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  final Message message;

  final User currentUser;

  const _Message({
    Key? key,
    required this.message,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = message.from.id == currentUser.id;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {},
              child: Text(
                message.from.username,
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: isMe ? Colors.white : Colors.blue,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    offset: Offset(2, 2),
                    color: Colors.black12,
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Text(
                message.message,
                style: TextStyle(color: isMe ? Colors.black : Colors.white),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              DateFormat('M/d/yy, h:mm a').format(message.createdAtDate),
              style: TextStyle(fontSize: 9),
            )
          ],
        )
      ],
    );
  }
}
