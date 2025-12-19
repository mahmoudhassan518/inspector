import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:inspector_core/inspector_core.dart';
import 'package:inspector/features/auth/navigation/auth_routes.dart';

/// App router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigationService.navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Home route
      GoRoute(
        path: '/',
        name: 'home',
        builder: withRebuildKey((context, state) => const _HomePlaceholder()),
      ),
      // Auth routes
      ...AuthRoutes.routes,
      // Add more feature routes here:
      // ...HomeRoutes.routes,
      // ...SettingsRoutes.routes,
    ],
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
    redirect: (context, state) {
      // Add auth redirect logic here
      // final isLoggedIn = authProvider.isLoggedIn;
      // final isAuthRoute = state.matchedLocation.startsWith('/login');
      // if (!isLoggedIn && !isAuthRoute) return AuthRoutes.login;
      return null;
    },
  );
}

/// Home placeholder - replace with actual home page
class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.goToLogin(),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error page
class _ErrorPage extends StatelessWidget {
  final Exception? error;
  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            if (error != null) Text(error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
