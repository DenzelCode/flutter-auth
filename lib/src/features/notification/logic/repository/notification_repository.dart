import 'package:auth/src/app.dart';
import 'package:auth/src/core/socket.dart';
import 'package:auth/src/features/messages/views/screens/direct_message_screen.dart';
import 'package:auth/src/features/messages/views/widgets/messages.dart';
import 'package:auth/src/features/notification/logic/enums/notification_type.dart';
import 'package:auth/src/features/notification/logic/repository/subscription_repository.dart';
import 'package:auth/src/features/room/views/screens/room_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationRepository {
  FirebaseMessaging get _fcm => FirebaseMessaging.instance;

  final subscriptionRepository = SubscriptionRepository();

  Future<void> setup() async {
    await Firebase.initializeApp();

    _fcm.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
  }

  Future<void> init() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _handleBackgroundMessage(message),
    );

    FirebaseMessaging.onMessage.listen(
      (message) => _handleForegroundMessage(message),
    );
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final context = applicationKey.currentContext;

    if (context == null) {
      return;
    }

    final type = message.data['type'];

    SnackBar? snackBar;

    if (type == NotificationType.room.name &&
        !_isCurrentPartner(message.data['roomId'])) {
      snackBar = SnackBar(
        content: Text(
          'Message received from Room: ${message.data['roomTitle']}',
        ),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => _redirectToRoom(
            context,
            message.data['roomId'],
          ),
        ),
      );
    }

    if (type == NotificationType.direct.name &&
        !_isCurrentPartner(message.data['username'])) {
      snackBar = SnackBar(
        content: Text(
          'Message received from User: ${message.data['username']}',
        ),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => _redirectToUser(
            context,
            message.data['username'],
          ),
        ),
      );
    }

    if (snackBar == null) {
      return;
    }

    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    final context = applicationKey.currentContext;

    if (context == null) {
      return;
    }

    final type = message.data['type'];

    if (type == NotificationType.room.name) {
      _redirectToRoom(context, message.data['roomId']);
    }

    if (type == NotificationType.direct.name) {
      _redirectToUser(context, message.data['username']);
    }
  }

  _redirectToUser(BuildContext context, String username) {
    if (_isCurrentPartner(username)) {
      return;
    }

    Navigator.pushNamed(
      context,
      DirectMessageScreen.routeName,
      arguments: DirectMessageArguments(
        username: username,
        fromMessages: socketManager.socket.connected,
      ),
    );
  }

  _redirectToRoom(BuildContext context, String roomId) {
    if (_isCurrentPartner(roomId)) {
      return;
    }

    Navigator.pushNamed(
      context,
      RoomScreen.routeName,
      arguments: RoomArguments(
        roomId: roomId,
        fromMessages: socketManager.socket.connected,
      ),
    );
  }

  bool _isCurrentPartner(String partnerId) {
    return Messages.partnersHistory.length > 0 &&
        Messages.partnersHistory.last == partnerId;
  }

  Future<void> requestPermission() async {
    await _fcm.requestPermission();

    final token = await _fcm.getToken();

    if (token == null) {
      return;
    }

    await subscriptionRepository.registerSubscription(token);
  }

  Future<void> deleteSubscription() async {
    final token = await _fcm.getToken();

    if (token == null) {
      return;
    }

    return subscriptionRepository.deleteSubscription(token);
  }
}

final notificationRepository = NotificationRepository();
