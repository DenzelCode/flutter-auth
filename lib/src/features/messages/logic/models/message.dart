import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  late final String id;
  late final String message;
  late final String? to;
  late final String? room;
  late final User from;
  late final String createdAt;
  late final DateTime createdAtDate;

  Message({
    required this.id,
    required this.message,
    this.room,
    this.to,
    required this.from,
    required this.createdAt,
  }) : super();

  Message.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    message = json['message'];
    to = json['to'];
    room = json['room'];
    from = User.fromJson(json['from']);
    createdAt = json['createdAt'];
    createdAtDate = DateTime.parse(createdAt);
  }

  static List<Message> fromList(List<dynamic> list) {
    return list.map((e) => Message.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [id, message, to, from, createdAt];
}
