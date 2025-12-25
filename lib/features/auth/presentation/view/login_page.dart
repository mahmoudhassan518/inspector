import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:inspector/features/auth/presentation/model/auth_effects.dart';
import 'package:inspector/features/auth/presentation/model/auth_events.dart';
import 'package:inspector/features/auth/presentation/model/auth_state.dart';
import 'package:inspector/features/localization/localization_feature.dart';
import 'package:inspector/injection_container.dart';

/// Login page - provides BLoC via GetIt
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const CheckAuthStatus()),
      child: const _LoginPageContent(),
    );
  }
}

/// Login page content - stateful with builder and listener
class _LoginPageContent extends StatefulWidget {
  const _LoginPageContent();

  @override
  State<_LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<_LoginPageContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.login),
        actions: const [LanguageIconButton()],
      ),
      body: StateView(
        cubit: context.read<AuthBloc>().commonCubit,
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: _handleListener,
          builder: _buildContent,
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, AuthState state) {
    final effect = state.effect?.current;
    if (effect != null) _handleEffect(context, effect);
  }

  Widget _buildContent(BuildContext context, AuthState state) {
    final localizations = AppStrings.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: localizations.email,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.compose([
                  Validators.required(localizations.pleaseEnterEmail),
                  Validators.email(localizations.pleaseEnterValidEmail),
                ]),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: localizations.password,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
                validator: Validators.compose([
                  Validators.required(localizations.pleaseEnterPassword),
                  Validators.minLength(6, localizations.passwordMinLength),
                ]),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onLoginPressed,
                  child: Text(localizations.login),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => navigationService.navigateTo('/register'),
                child: Text(localizations.dontHaveAccount),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  void _handleEffect(BuildContext context, AuthEffect effect) {
    final localizations = AppStrings.of(context);

    switch (effect) {
      case NavigateToHome():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.loginSuccess),
            backgroundColor: Colors.green,
          ),
        );
        break;
      case NavigateToLogin():
        break;
      case ShowError():
        break;
      case ShowSuccess():
        break;
    }
  }
}
