import 'package:flutter/widgets.dart';
import 'package:inspector/l10n/app_localizations.dart';
import 'package:inspector_core/inspector_core.dart';

/// Global localization accessor - works without BuildContext
///
/// Usage:
/// - With context: `AppStrings.of(context).login`
/// - Without context: `AppStrings.current.login`
class AppStrings {
  /// Get localization with context (preferred)
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  /// Get localization without context (uses NavigationService)
  /// Note: Only works after app is built
  static AppLocalizations get current {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) {
      throw StateError(
        'AppStrings.current called before app is built. '
        'Use AppStrings.of(context) instead, or ensure the app is running.',
      );
    }
    return AppLocalizations.of(context)!;
  }

  /// Safe version that returns null if not available
  static AppLocalizations? get currentOrNull {
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return null;
    return AppLocalizations.of(context);
  }
}
