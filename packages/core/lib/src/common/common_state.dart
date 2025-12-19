import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Loading presentation type
enum LoadingPresentation { overlay, shimmer }

/// Alert type for snackbar
enum AlertType { success, warning, destructive, info }

/// Snackbar configuration
class SnackBarConfig extends Equatable {
  final bool showCloseIcon;
  final bool showRetry;
  final bool autoDismiss;
  final int durationSeconds;
  final VoidCallback? retryCallback;

  const SnackBarConfig({
    this.showCloseIcon = false,
    this.showRetry = false,
    this.autoDismiss = true,
    this.durationSeconds = 5,
    this.retryCallback,
  });

  @override
  List<Object?> get props => [showCloseIcon, showRetry, autoDismiss, durationSeconds];
}

/// Common state for loading and snackbar
class CommonState extends Equatable {
  final bool isLoading;
  final LoadingPresentation loadingPresentation;
  final String? message;
  final AlertType level;
  final SnackBarConfig snackBarConfig;

  const CommonState({
    this.isLoading = false,
    this.loadingPresentation = LoadingPresentation.overlay,
    this.message,
    this.level = AlertType.destructive,
    this.snackBarConfig = const SnackBarConfig(),
  });

  CommonState copyWith({
    bool? isLoading,
    LoadingPresentation? loadingPresentation,
    String? message,
    AlertType? level,
    SnackBarConfig? snackBarConfig,
  }) {
    return CommonState(
      isLoading: isLoading ?? this.isLoading,
      loadingPresentation: loadingPresentation ?? this.loadingPresentation,
      message: message,
      level: level ?? this.level,
      snackBarConfig: snackBarConfig ?? this.snackBarConfig,
    );
  }

  @override
  List<Object?> get props => [isLoading, loadingPresentation, message, level, snackBarConfig];
}
