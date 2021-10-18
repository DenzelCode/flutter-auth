import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationRepository {
  final _fcm = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    try {
      await _fcm.requestPermission();

      final token = _fcm.getToken();

      print(token);
    } catch (_) {}
  }
}

final notificationRepository = NotificationRepository();
