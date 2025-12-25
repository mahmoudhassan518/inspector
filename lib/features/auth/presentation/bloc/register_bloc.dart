import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/domain/usecases/usecases.dart';

import 'package:inspector/features/auth/presentation/model/register_effect.dart';
import 'package:inspector/features/auth/presentation/model/register_event.dart';
import 'package:inspector/features/auth/presentation/model/register_state.dart';
import 'package:inspector/features/auth/presentation/model/mapper/user_state_mapper.dart';

/// Register BLoC - single source of truth for register page
/// 
/// Manages:
/// - Form state (name, email, password, confirmPassword, birthDate)
/// - Validation (all fields including date)
/// - API calls with launchBlock
/// - Navigation effects
class RegisterBloc extends BaseBloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc({
    required RegisterUseCase registerUseCase,
    CommonCubit? commonCubit,
  })  : _registerUseCase = registerUseCase,
        super(RegisterState.initial(), commonCubit: commonCubit) {
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterBirthDateChanged>(_onBirthDateChanged);
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterReset>(_onReset);
  }

  void _onNameChanged(RegisterNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onEmailChanged(RegisterEmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(RegisterPasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onConfirmPasswordChanged(RegisterConfirmPasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  void _onBirthDateChanged(RegisterBirthDateChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(birthDate: event.birthDate));
  }

  Future<void> _onSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) async {
    // Mark as submitted to show validation errors
    emit(state.copyWith(hasSubmitted: true));

    // Check validation
    if (!state.isValid) {
      return;
    }

    // Call API using launchBlock
    await launchBlock(
      onStart: () => showLoading(),
      onError: (error, message) {
        hideLoading();
        showError(message ?? 'Registration failed');
      },
      block: () async {
        final user = await _registerUseCase(RegisterParams(
          email: state.email,
          password: state.password,
          name: state.name,
        ));
        hideLoading();
        emit(state.copyWith(
          effect: SingleEffect(RegisterNavigateToHome(user: user.toStateModel())),
        ));
      },
    );
  }

  void _onReset(RegisterReset event, Emitter<RegisterState> emit) {
    emit(RegisterState.initial());
  }
}


