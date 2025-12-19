# Navigation

## NavigationService (Core Package)

`packages/core/lib/src/navigation/navigation_service.dart`

Global navigation service for programmatic navigation:

```dart
import 'package:inspector_core/inspector_core.dart';

// Navigate with push
navigationService.navigateTo('/profile');

// Navigate and clear stack (replaces current)
navigationService.navigateTo('/home', clearTop: true);

// Go directly (replace)
navigationService.go('/login');

// Go back
navigationService.back();

// Pop with result
navigationService.pop(context, result);
```

## App Router

`lib/navigation/app_router.dart`

```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigationService.navigatorKey,  // Uses NavigationService key
    routes: [
      GoRoute(path: '/', builder: ...),
      ...AuthRoutes.routes,
      ...HomeRoutes.routes,
    ],
  );
}
```

## Feature Routes

Each feature has its own navigation folder:

```
features/{feature}/
└── navigation/
    ├── {feature}_routes.dart   # Routes + extensions
    └── navigation.dart         # Barrel
```

### Example: Auth Routes

```dart
// features/auth/navigation/auth_routes.dart

class AuthRoutes {
  static const String login = '/login';
  static const String register = '/register';
  
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

extension AuthNavigation on BuildContext {
  void goToLogin({bool clearTop = false}) {
    if (clearTop) {
      navigationService.navigateTo(AuthRoutes.login, clearTop: true);
    } else {
      go(AuthRoutes.login);
    }
  }
  
  void goToRegister() => go(AuthRoutes.register);
}
```

## withRebuildKey Helper

Forces page rebuild when using `clearTop: true`:

```dart
GoRoute(
  path: '/home',
  builder: withRebuildKey((context, state) => const HomePage()),
)
```

## Usage

```dart
// Using extensions (recommended)
context.goToLogin();
context.goToLogin(clearTop: true);  // Clears stack

// Using NavigationService directly
navigationService.navigateTo('/profile');
navigationService.go('/home');
navigationService.back();

// Standard go_router
context.go('/login');
context.push('/profile');
```

## Adding Feature Routes

1. Create `features/{feature}/navigation/{feature}_routes.dart`
2. Add routes to `AppRouter`:

```dart
routes: [
  ...AuthRoutes.routes,
  ...NewFeatureRoutes.routes,  // Add here
],
```
