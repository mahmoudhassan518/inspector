import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common_state.dart';

/// Global common cubit instance for global toasts
late CommonCubit globalCommonCubit;

/// CommonCubit for managing loading and snackbar states
class CommonCubit extends Cubit<CommonState> {
  CommonCubit() : super(const CommonState());

  Timer? _snackBarTimer;

  void setLoading(
    bool isLoading, {
    LoadingPresentation presentation = LoadingPresentation.overlay,
  }) {
    if (!isClosed) {
      emit(
        state.copyWith(
          isLoading: isLoading,
          loadingPresentation: isLoading ? presentation : LoadingPresentation.overlay,
        ),
      );
    }
  }

  void showSnackBar({
    required String? message,
    AlertType level = AlertType.destructive,
    bool autoDismiss = true,
    bool showCloseIcon = false,
    int durationSeconds = 5,
    VoidCallback? onRetry,
  }) {
    _snackBarTimer?.cancel();

    final hasRetry = onRetry != null;
    final config = SnackBarConfig(
      showCloseIcon: showCloseIcon,
      showRetry: hasRetry,
      autoDismiss: hasRetry ? false : autoDismiss,
      durationSeconds: durationSeconds,
      retryCallback: onRetry,
    );

    if (!isClosed) {
      emit(state.copyWith(message: message, level: level, snackBarConfig: config));

      if (config.autoDismiss) {
        _snackBarTimer = Timer(Duration(seconds: durationSeconds), clearSnackBar);
      }
    }
  }

  void clearSnackBar() {
    _snackBarTimer?.cancel();
    if (!isClosed) {
      emit(state.copyWith(message: null));
    }
  }

  void clearState() {
    _snackBarTimer?.cancel();
    if (!isClosed) {
      emit(const CommonState());
    }
  }

  @override
  Future<void> close() {
    _snackBarTimer?.cancel();
    return super.close();
  }
}

/// Show global toast using globalCommonCubit
void showGlobalToast({
  required String message,
  AlertType level = AlertType.destructive,
  bool showCloseIcon = true,
  int durationSeconds = 3,
}) {
  globalCommonCubit.showSnackBar(
    message: message,
    level: level,
    showCloseIcon: showCloseIcon,
    durationSeconds: durationSeconds,
  );
}
