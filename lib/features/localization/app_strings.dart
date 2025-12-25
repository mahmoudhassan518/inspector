import 'package:flutter/widgets.dart';
import 'package:inspector/l10n/app_localizations.dart';
import 'package:inspector_core/inspector_core.dart';

/// Global localization instance - updated by app builder
/// 
/// This gets set in the MaterialApp.builder callback whenever the locale changes.
/// Use [AppStrings.current] to access it, or [AppStrings.of(context)] when you have context.
late AppLocalizations _globalLocalizations;

/// Check if global localizations has been initialized
bool _isInitialized = false;

/// Initialize global localizations (call from MaterialApp.builder)
/// 
/// This should be called in your app's builder:
/// ```dart
/// MaterialApp.router(
///   builder: (context, child) {
///     AppStrings.init(context);
///     return child;
///   },
/// )
/// ```
void initAppStrings(BuildContext context) {
  _globalLocalizations = AppLocalizations.of(context)!;
  _isInitialized = true;
}

/// Global localization accessor - works without BuildContext
///
/// Usage:
/// - With context: `AppStrings.of(context).login`
/// - Without context: `AppStrings.current.login`
/// 
/// Note: [current] requires [initAppStrings] to be called first (in MaterialApp.builder)
class AppStrings {
  AppStrings._();
  
  /// Initialize global localizations (call from MaterialApp.builder)
  /// 
  /// This ensures [AppStrings.current] always returns the correct locale.
  static void init(BuildContext context) => initAppStrings(context);
  
  /// Get localization with context (preferred, always up-to-date)
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  /// Get localization without context (uses global instance)
  /// 
  /// Note: Requires [init] to be called first (in MaterialApp.builder).
  /// This is automatically updated when locale changes.
  static AppLocalizations get current {
    if (!_isInitialized) {
      // Fallback to navigator context if not initialized
      final context = navigationService.navigatorKey.currentContext;
      if (context == null) {
        throw StateError(
          'AppStrings.current called before app is built. '
          'Use AppStrings.of(context) instead, or call AppStrings.init(context) in MaterialApp.builder.',
        );
      }
      return AppLocalizations.of(context)!;
    }
    return _globalLocalizations;
  }

  /// Safe version that returns null if not available
  static AppLocalizations? get currentOrNull {
    if (_isInitialized) return _globalLocalizations;
    
    final context = navigationService.navigatorKey.currentContext;
    if (context == null) return null;
    return AppLocalizations.of(context);
  }
}

