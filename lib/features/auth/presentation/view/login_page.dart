import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/di/auth_injection_container.dart';
import 'package:inspector/features/auth/navigation/auth_routes.dart';
import 'package:inspector/features/auth/presentation/bloc/login_bloc.dart';
import 'package:inspector/features/auth/presentation/model/login_effect.dart';
import 'package:inspector/features/auth/presentation/model/login_event.dart';
import 'package:inspector/features/auth/presentation/model/login_state.dart';
import 'package:inspector/features/localization/localization_feature.dart';

/// Login page with state-based validation
/// 
/// Uses single LoginBloc for:
/// - Form state (email, password, validation)
/// - API calls with launchBlock
/// - Navigation effects
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: const _LoginPageContent(),
    );
  }
}

class _LoginPageContent extends StatelessWidget {
  const _LoginPageContent();

  @override
  Widget build(BuildContext context) {
    final localizations = AppStrings.of(context);
    final bloc = context.read<LoginBloc>();

    return BlocListener<LoginBloc, LoginState>(
      listener: _handleEffect,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.login),
          actions: const [
            LanguageIconButton(),
          ],
        ),
        body: StateView(
          cubit: bloc.commonCubit,
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 48),
                      
                      // Email field
                      TextFormField(
                        initialValue: state.email,
                        decoration: InputDecoration(
                          labelText: localizations.email,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email),
                          // Error from state validator (language-aware!)
                          errorText: state.emailValidator.errorMessage,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (v) => bloc.add(LoginEmailChanged(v)),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Password field
                      TextFormField(
                        initialValue: state.password,
                        decoration: InputDecoration(
                          labelText: localizations.password,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          // Error from state validator (language-aware!)
                          errorText: state.passwordValidator.errorMessage,
                        ),
                        obscureText: true,
                        onChanged: (v) => bloc.add(LoginPasswordChanged(v)),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Remember me checkbox
                      CheckboxListTile(
                        title: Text(localizations.rememberMe),
                        value: state.rememberMe,
                        onChanged: (_) => bloc.add(LoginRememberMeToggled()),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => bloc.add(LoginSubmitted()),
                          child: Text(localizations.login),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Register link
                      TextButton(
                        onPressed: () => context.goToRegister(),
                        child: Text(localizations.dontHaveAccount),
                      ),
                      
                      const SizedBox(height: 48),
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

  void _handleEffect(BuildContext context, LoginState state) {
    final effect = state.effect?.current;
    if (effect == null) return;

    final localizations = AppStrings.of(context);

    if (effect is LoginNavigateToHome) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.loginSuccess),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to home
      navigationService.navigateTo('/home');
    }
  }
}
