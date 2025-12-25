import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:inspector_core/inspector_core.dart';
import 'package:inspector/features/auth/presentation/view/login_page.dart';
import 'package:inspector/features/auth/presentation/view/register_page.dart';

/// Auth feature routes
class AuthRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  /// Get all auth routes
  static List<RouteBase> routes = [
    GoRoute(
      path: login,
      name: 'login',
      builder: withRebuildKey((context, state) => const LoginPage()),
    ),
    GoRoute(
      path: register,
      name: 'register',
      builder: withRebuildKey((context, state) => const RegisterPage()),
    ),
  ];
}

/// Auth navigation extensions
extension AuthNavigation on BuildContext {
  void goToLogin({bool clearTop = false}) {
    if (clearTop) {
      navigationService.navigateTo(AuthRoutes.login, clearTop: true);
    } else {
      go(AuthRoutes.login);
    }
  }

  void goToRegister() => navigationService.navigateTo(AuthRoutes.register);
  void goToForgotPassword() => navigationService.navigateTo(AuthRoutes.forgotPassword);
}
