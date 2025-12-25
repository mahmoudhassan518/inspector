import 'package:equatable/equatable.dart';

/// User state model - presentation layer model
class UserStateModel extends Equatable {
  final String? id;
  final String? email;
  final String? name;
  final String? avatarUrl;
  final String displayName;

  const UserStateModel({
    this.id,
    this.email,
    this.name,
    this.avatarUrl,
    required this.displayName,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl, displayName];
}


