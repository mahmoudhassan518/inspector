import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/domain/usecases/usecases.dart';
import 'package:inspector/features/auth/presentation/model/auth_effects.dart';
import 'package:inspector/features/auth/presentation/model/auth_events.dart';
import 'package:inspector/features/auth/presentation/model/auth_state.dart';
import 'package:inspector/features/auth/presentation/model/mapper/user_state_mapper.dart';

/// Auth BLoC - manages authentication state
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc({
    CommonCubit? commonCubit,
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        super(AuthState.initial(), commonCubit: commonCubit) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    await launchBlock(
      onStart: () => showLoading(),
      onError: (error, message) {
        hideLoading();
        showError(message ?? 'Login failed');
      },
      block: () async {
        final user = await _loginUseCase(LoginParams(
          email: event.email,
          password: event.password,
        ));
        hideLoading();
        emit(state.copyWith(
          isAuthenticated: true,
          user: user.toStateModel(),
          effect: SingleEffect(const NavigateToHome()),
        ));
      },
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    await launchBlock(
      onStart: () => showLoading(),
      onError: (error, message) {
        hideLoading();
        showError(message ?? 'Registration failed');
      },
      block: () async {
        final user = await _registerUseCase(RegisterParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ));
        hideLoading();
        emit(state.copyWith(
          isAuthenticated: true,
          user: user.toStateModel(),
          effect: SingleEffect(const NavigateToHome()),
        ));
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await launchBlock(
      onStart: () => showLoading(),
      onError: (error, message) {
        hideLoading();
        showError(message ?? 'Logout failed');
      },
      block: () async {
        await _logoutUseCase(const NoParams());
        hideLoading();
        emit(AuthState.initial().copyWith(
          effect: SingleEffect(const NavigateToLogin()),
        ));
      },
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    await launchBlock(
      onStart: () => showLoading(),
      onError: (error, message) {
        hideLoading();
        emit(state.copyWith(isAuthenticated: false));
      },
      block: () async {
        final user = await _getCurrentUserUseCase(const NoParams());
        hideLoading();
        if (user != null) {
          emit(state.copyWith(
            isAuthenticated: true,
            user: user.toStateModel(),
          ));
        } else {
          emit(state.copyWith(isAuthenticated: false));
        }
      },
    );
  }
}
