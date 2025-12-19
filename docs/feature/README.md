# Feature Structure

```
features/[feature]/
├── di/
│   └── {feature}_injection_container.dart
├── {feature}_feature.dart      # Barrel export
├── data/
│   ├── model/
│   │   ├── {name}_response.dart
│   │   └── mapper/{name}_mapper.dart
│   ├── repository/
│   └── source/
├── domain/
│   ├── model/{name}_entity.dart
│   ├── repository/
│   └── usecases/
└── presentation/
    ├── model/
    │   ├── {feature}_events.dart
    │   ├── {feature}_effects.dart
    │   ├── {feature}_state.dart
    │   └── mapper/
    ├── bloc/
    ├── view/
    └── widget/
```

## Mapper Flow

```
Response → Entity → StateModel
  (data)   (domain)   (presentation)
```

## Layer Docs

- [Domain](./domain.md)
- [Data](./data.md)
- [Presentation](./presentation.md)
- [DI](./di.md)
