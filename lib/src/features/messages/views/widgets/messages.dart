import 'dart:async';

import 'package:auth/src/features/auth/logic/cubit/auth_cubit.dart';
import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/messages/logic/bloc/message_bloc.dart';
import 'package:auth/src/features/messages/logic/enum/message_type.dart';
import 'package:auth/src/features/messages/logic/models/message.dart';
import 'package:auth/src/features/messages/views/screens/direct_message_screen.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:auth/src/shared/views/widgets/dialog/confirm_dialog_widget.dart';
import 'package:auth/src/shared/views/widgets/typing_indicator.dart';
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

  final _scrollToLastOffset = 50;

  final _textController = TextEditingController();

  Timer? _typingTimer;

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    widget.bloc.add(MessagesLoadedEvent());

    _scrollController.addListener(_onScroll);

    _textController.addListener(_onTyping);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();

    _textController.dispose();

    _typingTimer?.cancel();
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

        if (state is MessageReceiveState || state is MessageTypingState) {
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
                      controller: _textController,
                      decoration: InputDecoration(labelText: 'Message'),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Material(
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ),
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

  void _onTyping() {
    if (_isTyping) {
      return;
    }

    _isTyping = true;

    context.read<MessageBloc>().sendTyping();

    _typingTimer = Timer(
      Duration(milliseconds: widget.bloc.typingTimeout - 1000),
      () => _isTyping = false,
    );
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) {
      return;
    }

    context
        .read<MessageBloc>()
        .sendMessage(_textController.text, (data) => _textController.clear());
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

            return ListView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                for (final message in state.messages)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message == state.messages[0])
                          SizedBox(
                            height: 20,
                          ),
                        _Message(
                          message: message,
                          from: message.from,
                          currentUser: user,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                for (final typing in state.usersTyping)
                  if (typing.id != user.id)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Message(
                            from: typing,
                            currentUser: user,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Message extends StatefulWidget {
  final User from;
  final Message? message;

  final User currentUser;

  const _Message({
    Key? key,
    required this.from,
    required this.currentUser,
    this.message,
  }) : super(key: key);

  @override
  __MessageState createState() => __MessageState();
}

class __MessageState extends State<_Message> {
  bool _showDelete = false;

  @override
  Widget build(BuildContext context) {
    final isMe = widget.from.id == widget.currentUser.id;

    Widget messageWidget = TypingIndicator();

    final maxWidth = MediaQuery.of(context).size.width * 0.7;

    if (widget.message != null) {
      messageWidget = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Text(
          (widget.message as Message).message,
          style: TextStyle(color: isMe ? Colors.black : Colors.white),
        ),
      );
    }

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                DirectMessageScreen.routeName,
                arguments: DirectMessageArguments(
                  username: widget.from.username,
                  fromMessages: true,
                ),
              ),
              child: Text(
                widget.from.username,
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () => setState(() {
                _showDelete = !_showDelete;
              }),
              child: Row(
                children: [
                  if (isMe && _showDelete)
                    IconButton(
                      onPressed: _showRemoveMessageDialog,
                      icon: Icon(Icons.delete),
                    ),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: isMe || widget.message == null
                          ? Colors.white
                          : Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topLeft: Radius.circular(!isMe ? 0 : 8),
                        topRight: Radius.circular(isMe ? 0 : 8),
                      ),
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
                    child: messageWidget,
                  ),
                  if (!isMe && _showDelete)
                    IconButton(
                      onPressed: _showRemoveMessageDialog,
                      icon: Icon(Icons.delete),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            if (widget.message != null)
              Text(
                DateFormat('M/d/yy, h:mm a')
                    .format((widget.message as Message).createdAtDate),
                style: TextStyle(fontSize: 9),
              )
          ],
        )
      ],
    );
  }

  Future<void> _showRemoveMessageDialog() async {
    final response = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialogWidget(),
    );

    if (response != null && response) {
      _removeMessage();
    }
  }

  void _removeMessage() {
    context
        .read<MessageBloc>()
        .add(MessageDeletedRequestEvent(widget.message as Message));
  }
}
