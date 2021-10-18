import 'package:auth/src/features/notification/logic/repository/subscription_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationRepository {
  FirebaseMessaging get _fcm => FirebaseMessaging.instance;

  final subscriptionRepository = SubscriptionRepository();

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
