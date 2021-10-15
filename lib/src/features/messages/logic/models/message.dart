import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  late final String id;
  late final String message;
  late final String? to;
  late final String? room;
  late final User from;
  late final String createdAt;

  Message({
    required this.id,
    required this.message,
    this.room,
    this.to,
    required this.from,
    required this.createdAt,
  }) : super();

  Message.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.message = json['message'];
    this.to = json['to'];
    this.room = json['room'];
    this.from = User.fromJson(json['from']);
    this.createdAt = json['createdAt'];
  }

  static List<Message> fromList(List<dynamic> list) {
    return list.map((e) => Message.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [id, message, to, from, createdAt];
}
