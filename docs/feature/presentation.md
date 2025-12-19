# Presentation Layer

## Structure

```
presentation/
├── model/
│   ├── {feature}_events.dart
│   ├── {feature}_effects.dart  
│   └── {feature}_state.dart
├── bloc/
│   └── {feature}_bloc.dart
├── view/
│   └── {name}_page.dart
└── widget/
```

## Page Pattern

```dart
/// StatelessWidget - provides BLoC via GetIt
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _LoginPageContent(),
    );
  }
}

/// StatefulWidget - has builder and listener
class _LoginPageContent extends StatefulWidget {
  const _LoginPageContent();
  @override
  State<_LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<_LoginPageContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    if (effect != null) { /* handle effect */ }
  }
  
  Widget _buildContent(BuildContext context, AuthState state) => ...;
}
```

## State

```dart
class AuthState extends Equatable {
  final bool isAuthenticated;
  final UserStateModel? user;
  final SingleEffect<AuthEffect>? effect;
  
  @override
  List<Object?> get props => [isAuthenticated, user, effect];
}
```

## BLoC with Error Handling

```dart
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  
  AuthBloc({required this.loginUseCase, CommonCubit? commonCubit}) 
    : super(AuthState(), commonCubit: commonCubit);

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    await launchBlock(
      onStart: showLoading,
      onError: (error, message) {
        hideLoading();
        if (error is BusinessException) {
          switch (error.errorCode) {
            case AuthErrorCodes.userNotVerified:
              emit(state.copyWith(needsVerification: true));
              return;
          }
        }
        showError(message ?? 'Error');
      },
      block: () async {
        final user = await loginUseCase(LoginParams(...));
        hideLoading();
        emit(state.copyWith(isAuthenticated: true, user: user));
      },
    );
  }
}
```
