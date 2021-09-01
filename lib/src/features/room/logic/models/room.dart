import 'package:auth/src/features/auth/logic/models/user.dart';

class Room<M, O> {
  late final String id;
  late final String title;
  late final bool isPublic;
  late final List<M> members;
  late final O owner;

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

    if (M.runtimeType == User) {
      members = (json['members'] as List<dynamic>)
          .map((e) => User.fromJson(e))
          .toList() as List<M>;

      owner = json['owner'];
    } else {
      members = json['members'];

      owner = json['owner'];
    }
  }

  static List<Room<M, O>> fromList<M, O>(List<Map<String, dynamic>> list) {
    return list.map((e) => Room.fromJson(e) as Room<M, O>).toList();
  }
}
