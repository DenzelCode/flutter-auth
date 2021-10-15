import 'package:auth/src/features/auth/logic/interceptors/auth_token_interceptor.dart';
import 'package:auth/src/features/messages/logic/enum/message_type.dart';
import 'package:auth/src/features/messages/logic/models/message.dart';
import 'package:auth/src/shared/logic/http/api.dart';

class MessageAPIProvider {
  Future<List<Message>> getMessages(
    MessageType type,
    String id,
    int limit,
    String? before,
  ) async {
    final params = {'limit': limit, 'before': before};

    for (String key in [...params.keys]) {
      if (params[key] == null) {
        params.remove(key);
      }
    }

    final response = await api.get('/message/${type.name}/$id');

    return Message.fromList(response.data);
  }

  Future<Message> getFirstMessage(MessageType type, String id) async {
    final response = await api.get('/message/${type.name}-first-message/$id');

    return Message.fromJson(response.data);
  }

  Future<Message> deleteMessage(MessageType type, Message message) async {
    final response = await api.delete(
      '/message/${type.name}',
      data: {
        'messageId': message.id,
        'roomId': message.room,
        'to': message.to,
      },
      options: Options(headers: {
        AuthTokenInterceptor.skipHeader: true,
      }),
    );

    return Message.fromJson(response.data);
  }
}
