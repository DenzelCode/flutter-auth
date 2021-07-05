class AccessToken {
  late String accessToken;

  AccessToken({required this.accessToken});

  AccessToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
  }
}
