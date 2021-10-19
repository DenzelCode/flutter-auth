enum NotificationType { direct, room }

extension NotificationTypeExtension on NotificationType {
  String get name {
    switch (this) {
      case NotificationType.direct:
        return 'direct';
      default:
        return 'room';
    }
  }
}
