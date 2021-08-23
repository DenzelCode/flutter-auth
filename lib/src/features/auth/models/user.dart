class User {
  late String id;
  late String username;
  late String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    email = json['email'];
  }
}
