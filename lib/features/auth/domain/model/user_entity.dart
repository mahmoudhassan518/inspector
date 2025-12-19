import 'package:equatable/equatable.dart';

/// User entity - domain layer representation
class UserEntity extends Equatable {
  final String? id;
  final String? email;
  final String? name;
  final String? avatarUrl;

  const UserEntity({
    this.id,
    this.email,
    this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl];
}
