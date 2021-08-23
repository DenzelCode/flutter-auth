class Tokens {
  late String accessToken;
  late String refreshToken;

  Tokens({required this.accessToken});

  Tokens.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }
}
