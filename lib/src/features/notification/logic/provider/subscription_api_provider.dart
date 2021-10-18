import 'package:auth/src/shared/logic/http/api.dart';

class SubscriptionAPIProvider {
  Future<void> registerSubscription(String token) async {
    await api.post('/subscription/mobile', data: {'subscription': token});
  }

  Future<void> deleteSubscription(String token) async {
    await api.delete('/subscription/mobile', data: {'subscription': token});
  }
}
