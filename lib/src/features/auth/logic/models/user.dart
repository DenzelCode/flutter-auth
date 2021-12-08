import 'package:equatable/equatable.dart';

class User extends Equatable implements Comparable {
  late final String id;
  late final String username;
  late final String? email;
  late final bool online;
  late final bool isSocial;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.online,
    this.isSocial = false,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'] ?? '';
    email = json['email'];
    online = json['online'] ?? false;
    isSocial = json['isSocial'] ?? false;
  }

  static List<User> fromList(List<dynamic> list) {
    return list.map((e) => User.fromJson(e)).toList();
  }

  @override
  int compareTo(dynamic other) {
    if (this.online == other.online) {
      return 0;
    }

    if (this.online) {
      return -1;
    }

    if (other.online) {
      return 1;
    }

    return 0;
  }

  @override
  List<Object?> get props => [id, username, email, online];
}
