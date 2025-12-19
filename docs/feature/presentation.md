# Presentation Layer

## Structure

```
presentation/
├── model/
│   ├── {feature}_events.dart
│   ├── {feature}_effects.dart  
│   ├── {feature}_state.dart    # Data only
│   └── mapper/
│       └── {name}_state_mapper.dart
├── bloc/
├── view/
│   └── {name}_page.dart  # StatelessWidget + _Content StatefulWidget
└── widget/
```

## Page Pattern

Two classes per page:

```dart
/// 1. StatelessWidget - provides BLoC via GetIt
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

/// 2. StatefulWidget - has builder and listener
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
    if (effect != null) handleEffect(effect);
  }
  
  Widget _buildContent(BuildContext context, AuthState state) => ...;
}
```

## State (Data Only)

```dart
class AuthState extends Equatable {
  final bool isAuthenticated;
  final UserStateModel? user;
  final SingleEffect<AuthEffect>? effect;
}
```

## State Mapper

`presentation/model/mapper/{name}_state_mapper.dart`

```dart
extension UserEntityToStateMapper on UserEntity {
  UserStateModel toStateModel() => UserStateModel(
    displayName: name ?? email ?? 'User',
  );
}
```

## BLoC

```dart
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc({CommonCubit? commonCubit}) 
    : super(AuthState(), commonCubit: commonCubit);

  Future<void> _onLogin(event, emit) async {
    await launchBlock(
      onStart: () => showLoading(),
      onError: (e, msg) { hideLoading(); showError(msg); },
      block: () async {
        final user = await loginUseCase(...);
        hideLoading();
        emit(state.copyWith(user: user.toStateModel()));
      },
    );
  }
}
```
