class User {
  late final String id;
  late final String username;
  late final String email;
  late final bool online;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.online,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    email = json['email'];
    online = json['online'];
  }
}
