import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:equatable/equatable.dart';

class Typing extends Equatable {
  late final Room? room;
  late final User user;

  Typing({this.room, required this.user}) : super();

  Typing.fromJson(Map<String, dynamic> json) {
    room = json['room'] != null ? Room.fromJson(json['room']) : null;
    user = User.fromJson(json['user']);
  }

  @override
  List<Object?> get props => [room, user];
}
