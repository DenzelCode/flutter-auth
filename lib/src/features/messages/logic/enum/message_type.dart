enum MessageType { room, direct }

extension MessageTypeExtension on MessageType {
  String get name {
    switch (this) {
      case MessageType.direct:
        return 'direct';
      default:
        return 'room';
    }
  }
}
