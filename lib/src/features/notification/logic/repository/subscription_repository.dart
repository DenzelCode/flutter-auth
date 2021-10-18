import 'package:auth/src/features/notification/logic/provider/subscription_api_provider.dart';

class SubscriptionRepository {
  final _provider = SubscriptionAPIProvider();

  Future<void> registerSubscription(String token) =>
      _provider.registerSubscription(token);

  Future<void> deleteSubscription(String token) =>
      _provider.deleteSubscription(token);
}
