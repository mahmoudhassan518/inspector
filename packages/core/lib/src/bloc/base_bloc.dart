import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inspector_core/src/common/common_cubit.dart';
import 'package:inspector_core/src/common/common_state.dart';

/// Base bloc with error handling and optional CommonCubit integration
abstract class BaseBloc<E, S> extends Bloc<E, S> {
  final CommonCubit? commonCubit;

  BaseBloc(super.initialState, {this.commonCubit});

  /// Launches an async block with error handling
  Future<void> launchBlock({
    VoidCallback? onStart,
    void Function(Object error, String? message)? onError,
    required Future<void> Function() block,
  }) async {
    try {
      onStart?.call();
      await block();
    } catch (e) {
      final message = e.toString();
      onError?.call(e, message);
    }
  }

  /// Show loading via CommonCubit
  void showLoading({LoadingPresentation presentation = LoadingPresentation.overlay}) {
    commonCubit?.setLoading(true, presentation: presentation);
  }

  /// Hide loading via CommonCubit
  void hideLoading() {
    commonCubit?.setLoading(false);
  }

  /// Show error message via CommonCubit
  void showError(String message, {VoidCallback? onRetry}) {
    commonCubit?.showSnackBar(
      message: message,
      level: AlertType.destructive,
      onRetry: onRetry,
    );
  }

  /// Show success message via CommonCubit
  void showSuccess(String message) {
    commonCubit?.showSnackBar(
      message: message,
      level: AlertType.success,
    );
  }

  @override
  Future<void> close() {
    commonCubit?.clearState();
    return super.close();
  }
}

typedef VoidCallback = void Function();
