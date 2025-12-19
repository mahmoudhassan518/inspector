/// User response model from remote API
/// All fields are nullable as per API response handling
class UserResponse {
  final String? id;
  final String? email;
  final String? name;
  final String? avatarUrl;
  final String? accessToken;
  final String? refreshToken;

  const UserResponse({
    this.id,
    this.email,
    this.name,
    this.avatarUrl,
    this.accessToken,
    this.refreshToken,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
      accessToken: json['access_token'] as String? ?? json['accessToken'] as String?,
      refreshToken: json['refresh_token'] as String? ?? json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}
