import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/domain/usecases/usecases.dart';

import 'package:inspector/features/auth/presentation/model/login_effect.dart';
import 'package:inspector/features/auth/presentation/model/login_event.dart';
import 'package:inspector/features/auth/presentation/model/login_state.dart';
import 'package:inspector/features/auth/presentation/model/mapper/user_state_mapper.dart';

/// Login BLoC - single source of truth for login page
/// 
/// Manages:
/// - Form state (email, password, validation)
/// - API calls with launchBlock (loading/error handling)
/// - Navigation effects
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({
    required LoginUseCase loginUseCase,
    CommonCubit? commonCubit,
  })  : _loginUseCase = loginUseCase,
        super(LoginState.initial(), commonCubit: commonCubit) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginRememberMeToggled>(_onRememberMeToggled);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginReset>(_onReset);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onRememberMeToggled(LoginRememberMeToggled event, Emitter<LoginState> emit) {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    // Mark as submitted to show validation errors
    emit(state.copyWith(hasSubmitted: true));

    // Check validation
    if (!state.isValid) {
      return;
    }

    // Call API using launchBlock (handles loading/error)
    await launchBlock(
      onStart: () => showLoading(),
      onError: (error, message) {
        hideLoading();
        showError(message ?? 'Login failed');
      },
      block: () async {
        final user = await _loginUseCase(LoginParams(
          email: state.email,
          password: state.password,
        ));
        hideLoading();
        emit(state.copyWith(
          effect: SingleEffect(LoginNavigateToHome(user: user.toStateModel())),
        ));
      },
    );
  }

  void _onReset(LoginReset event, Emitter<LoginState> emit) {
    emit(LoginState.initial());
  }
}


