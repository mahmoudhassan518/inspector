import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:inspector/features/auth/presentation/model/auth_effects.dart';
import 'package:inspector/features/auth/presentation/model/auth_events.dart';
import 'package:inspector/features/auth/presentation/model/auth_state.dart';
import 'package:inspector/features/localization/localization_feature.dart';
import 'package:inspector/injection_container.dart';

/// Register page - provides BLoC via GetIt
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _RegisterPageContent(),
    );
  }
}

/// Register page content - stateful with builder and listener
class _RegisterPageContent extends StatefulWidget {
  const _RegisterPageContent();

  @override
  State<_RegisterPageContent> createState() => _RegisterPageContentState();
}

class _RegisterPageContentState extends State<_RegisterPageContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppStrings.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.register),
        actions: const [
          LanguageIconButton(),
        ],
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
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 40),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: localizations.name,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.pleaseEnterName;
                }
                if (value.length < 2) {
                  return localizations.pleaseEnterName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: localizations.email,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.pleaseEnterEmail;
                }
                if (!value.contains('@')) {
                  return localizations.pleaseEnterValidEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: localizations.password,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.pleaseEnterPassword;
                }
                if (value.length < 6) {
                  return localizations.passwordMinLength;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: localizations.confirmPassword,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.pleaseEnterPassword;
                }
                if (value != _passwordController.text) {
                  return localizations.passwordsDoNotMatch;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _onRegisterPressed,
                child: Text(localizations.register),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.alreadyHaveAccount),
            ),
          ],
        ),
      ),
    );
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterRequested(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
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
            content: Text(localizations.registerSuccess),
            backgroundColor: Colors.green,
          ),
        );
        break;
      case NavigateToLogin():
        Navigator.of(context).pop();
        break;
      case ShowError():
        break;
      case ShowSuccess():
        break;
    }
  }
}
