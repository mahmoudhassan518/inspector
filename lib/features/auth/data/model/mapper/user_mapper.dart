import 'package:inspector/features/auth/domain/model/user_entity.dart';
import 'package:inspector/features/auth/data/model/user_response.dart';

/// Extension to map UserResponse to UserEntity
extension UserResponseMapper on UserResponse {
  UserEntity toEntity() {
    return UserEntity(id: id, email: email, name: name, avatarUrl: avatarUrl);
  }
}

/// Extension to map UserEntity to UserResponse (for local caching)
extension UserEntityMapper on UserEntity {
  UserResponse toResponse() {
    return UserResponse(id: id, email: email, name: name, avatarUrl: avatarUrl);
  }
}
