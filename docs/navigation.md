# Navigation

## NavigationService (Core Package)

```dart
import 'package:inspector_core/inspector_core.dart';

// Navigate with push
navigationService.navigateTo('/profile');

// Navigate and clear stack
navigationService.navigateTo('/home', clearTop: true);

// Go directly (replace)
navigationService.go('/login');

// Go back
navigationService.back();
```

## App Router

Location: `lib/navigation/app_router.dart`

```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigationService.navigatorKey,
    routes: [
      GoRoute(path: '/', builder: ...),
      ...AuthRoutes.routes,
    ],
  );
}
```

## Feature Routes

Location: `features/{feature}/navigation/{feature}_routes.dart`

```dart
class AuthRoutes {
  static const String login = '/login';
  static const String register = '/register';
  
  static List<RouteBase> routes = [
    GoRoute(
      path: login,
      name: 'login',
      builder: withRebuildKey((ctx, state) => const LoginPage()),
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
}
```

## withRebuildKey

Forces page rebuild when using `clearTop: true`:

```dart
builder: withRebuildKey((ctx, state) => const HomePage())
```

## Adding Feature Routes

1. Create `features/{feature}/navigation/{feature}_routes.dart`
2. Add to AppRouter: `...NewRoutes.routes`
