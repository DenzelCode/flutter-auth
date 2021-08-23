class User {
  late String id;
  late String username;
  late String email;
  late bool online;

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
