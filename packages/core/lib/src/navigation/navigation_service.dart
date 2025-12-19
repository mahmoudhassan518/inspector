import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation service for app-wide navigation
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  GoRouter? _router() {
    final context = navigatorKey.currentContext;
    if (context == null) return null;
    return GoRouter.of(context);
  }

  /// Navigate to a route: push by default, or clear stack if [clearTop] is true
  Future<dynamic> navigateTo(
    String route, {
    bool clearTop = false,
    Object? extra,
  }) {
    final router = _router();
    if (router == null) return Future.value(null);

    if (clearTop) {
      router.go(
        '$route?ts=${DateTime.now().millisecondsSinceEpoch}',
        extra: extra,
      );
      return Future.value(null);
    } else {
      return router.push(route, extra: extra);
    }
  }

  void go(String route, {Object? extra}) {
    _router()?.go(route, extra: extra);
  }

  void replaceCurrent(String route, {Object? extra}) {
    _router()?.replace(route, extra: extra);
  }

  /// Go back to previous screen
  void back() {
    navigatorKey.currentState?.maybePop();
  }

  void pop<T>(BuildContext context, [T? result]) {
    context.pop<T>(result);
  }

  /// Go back then replace with a new route
  void backAndReplaceWith(String route, {Object? extra}) {
    back();
    replaceCurrent(route, extra: extra);
  }
}

/// Global navigation service instance
final NavigationService navigationService = NavigationService();

/// Wrapper to force widget rebuild when navigating with clearTop
/// Uses timestamp query param to create unique key
Widget Function(BuildContext, GoRouterState) withRebuildKey(
  Widget Function(BuildContext, GoRouterState) builder,
) {
  return (context, state) {
    final ts = state.uri.queryParameters['ts'];
    final builtWidget = builder(context, state);

    if (ts == null) {
      return builtWidget;
    }

    return KeyedSubtree(key: ValueKey(ts), child: builtWidget);
  };
}
