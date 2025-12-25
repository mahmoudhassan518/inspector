import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/di/auth_injection_container.dart';
import 'package:inspector/features/auth/presentation/bloc/register_bloc.dart';
import 'package:inspector/features/auth/presentation/model/register_effect.dart';
import 'package:inspector/features/auth/presentation/model/register_event.dart';
import 'package:inspector/features/auth/presentation/model/register_state.dart';
import 'package:inspector/features/localization/localization_feature.dart';

/// Register page with state-based validation
/// 
/// Uses single RegisterBloc for:
/// - Form state (name, email, password, birthDate)
/// - Validation (including date field)
/// - API calls with launchBlock
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
      child: const _RegisterPageContent(),
    );
  }
}

class _RegisterPageContent extends StatelessWidget {
  const _RegisterPageContent();

  @override
  Widget build(BuildContext context) {
    final localizations = AppStrings.of(context);
    final bloc = context.read<RegisterBloc>();

    return BlocListener<RegisterBloc, RegisterState>(
      listener: _handleEffect,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.register),
          actions: const [
            LanguageIconButton(),
          ],
        ),
        body: StateView(
          cubit: bloc.commonCubit,
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      
                      // Name field
                      TextFormField(
                        initialValue: state.name,
                        decoration: InputDecoration(
                          labelText: localizations.name,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person),
                          errorText: state.nameValidator.errorMessage,
                        ),
                        onChanged: (v) => bloc.add(RegisterNameChanged(v)),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Email field
                      TextFormField(
                        initialValue: state.email,
                        decoration: InputDecoration(
                          labelText: localizations.email,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email),
                          errorText: state.emailValidator.errorMessage,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (v) => bloc.add(RegisterEmailChanged(v)),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Birth Date picker (custom field example)
                      _BirthDateField(
                        value: state.birthDate,
                        errorMessage: state.birthDateValidator.errorMessage,
                        onDateSelected: (date) => bloc.add(RegisterBirthDateChanged(date)),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Password field
                      TextFormField(
                        initialValue: state.password,
                        decoration: InputDecoration(
                          labelText: localizations.password,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          errorText: state.passwordValidator.errorMessage,
                        ),
                        obscureText: true,
                        onChanged: (v) => bloc.add(RegisterPasswordChanged(v)),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Confirm Password field
                      TextFormField(
                        initialValue: state.confirmPassword,
                        decoration: InputDecoration(
                          labelText: localizations.confirmPassword,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          errorText: state.confirmPasswordValidator.errorMessage,
                        ),
                        obscureText: true,
                        onChanged: (v) => bloc.add(RegisterConfirmPasswordChanged(v)),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Register button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => bloc.add(RegisterSubmitted()),
                          child: Text(localizations.register),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Login link
                      TextButton(
                        onPressed: () => navigationService.pop(context),
                        child: Text(localizations.alreadyHaveAccount),
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleEffect(BuildContext context, RegisterState state) {
    final effect = state.effect?.current;
    if (effect == null) return;

    final localizations = AppStrings.of(context);

    if (effect is RegisterNavigateToHome) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.registerSuccess),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to home
      navigationService.navigateTo('/home');
    }
  }
}

/// Custom date picker field with error display
/// 
/// Example of how to use FieldValidator with non-text fields.
class _BirthDateField extends StatelessWidget {
  final DateTime? value;
  final String? errorMessage;
  final ValueChanged<DateTime> onDateSelected;

  const _BirthDateField({
    required this.value,
    required this.errorMessage,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppStrings.of(context);
    final dateFormat = DateFormat.yMMMd();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _showDatePicker(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: localizations.birthDate,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.calendar_today),
              errorText: errorMessage,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null 
                    ? dateFormat.format(value!) 
                    : localizations.selectDate,
                  style: value != null 
                    ? null 
                    : TextStyle(color: Theme.of(context).hintColor),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final minDate = DateTime(now.year - 100, 1, 1);
    final maxDate = DateTime(now.year - 10, 12, 31); // Max 10 years ago
    
    final selected = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: minDate,
      lastDate: maxDate,
    );
    
    if (selected != null) {
      onDateSelected(selected);
    }
  }
}
