import 'package:equatable/equatable.dart';

import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/presentation/model/auth_effects.dart';

/// Auth BLoC state - only holds data, no loading/error (handled by CommonCubit)
class AuthState extends Equatable {
  final bool isAuthenticated;
  final UserStateModel? user;
  final SingleEffect<AuthEffect>? effect;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.effect,
  });

  factory AuthState.initial() => const AuthState();

  AuthState copyWith({
    bool? isAuthenticated,
    UserStateModel? user,
    SingleEffect<AuthEffect>? effect,
    bool clearUser = false,
    bool clearEffect = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: clearUser ? null : (user ?? this.user),
      effect: clearEffect ? null : (effect ?? this.effect),
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, user, effect];
}

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
