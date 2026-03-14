class SignInEntity {
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  const SignInEntity({this.accessToken, this.refreshToken, this.expiresAt});
}
