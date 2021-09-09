import 'package:auth/src/features/auth/logic/models/user.dart';

class Room {
  late final String id;
  late final String title;
  late final bool isPublic;
  late final List<dynamic> members;
  late final dynamic owner;

  Room({
    required this.id,
    required this.title,
    required this.isPublic,
    required this.members,
    required this.owner,
  });

  Room.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    isPublic = json['isPublic'];

    if (json['members'].length > 0) {
      members = json['members'][0] is String
          ? json['members']
          : User.fromList(json['members']);
    } else {
      members = [];
    }

    owner =
        json['owner'] is String ? json['owner'] : User.fromJson(json['owner']);
  }

  static List<Room> fromList(List<dynamic> list) {
    return list.map((e) => Room.fromJson(e)).toList();
  }
}
