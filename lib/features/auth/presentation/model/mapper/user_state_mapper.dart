import 'package:inspector/features/auth/domain/model/user_entity.dart';
import 'package:inspector/features/auth/presentation/model/auth_state.dart';

/// Extension to map UserEntity to UserStateModel
extension UserEntityToStateMapper on UserEntity {
  UserStateModel toStateModel() {
    return UserStateModel(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      displayName: name ?? email ?? 'User',
    );
  }
}
