import 'package:auth/src/features/messages/logic/enum/message_type.dart';
import 'package:auth/src/features/messages/logic/models/message.dart';
import 'package:auth/src/features/messages/logic/providers/message_api_provider.dart';

class MessageRepository {
  final provider = MessageAPIProvider();

  Future<List<Message>> getMessages({
    required MessageType type,
    required String id,
    required int limit,
    String? before,
  }) {
    return provider.getMessages(type, id, limit, before);
  }

  Future<Message?> getFirstMessage(MessageType type, String id) {
    return provider.getFirstMessage(type, id);
  }

  Future<Message> deleteMessage(MessageType type, Message message) {
    return provider.deleteMessage(type, message);
  }
}
