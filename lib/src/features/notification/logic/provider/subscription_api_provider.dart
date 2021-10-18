import 'package:auth/src/features/auth/logic/interceptors/auth_token_interceptor.dart';
import 'package:auth/src/shared/logic/http/api.dart';
import 'package:auth/src/shared/logic/http/interceptors/error_dialog_interceptor.dart';

class SubscriptionAPIProvider {
  Future<void> registerSubscription(String token) async {
    await api.post('/subscription/mobile', data: {'subscription': token});
  }

  Future<void> deleteSubscription(String token) async {
    await api.delete(
      '/subscription/mobile',
      data: {'subscription': token},
      options: Options(headers: {
        AuthTokenInterceptor.skipHeader: true,
        ErrorDialogInterceptor.skipHeader: true,
      }),
    );
  }
}
