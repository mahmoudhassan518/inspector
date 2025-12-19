import 'package:equatable/equatable.dart';
import 'package:inspector/features/localization/localization_feature.dart';

/// Inspector events
sealed class InspectorEvent extends Equatable {
  const InspectorEvent();

  @override
  List<Object?> get props => [];
}

/// Change language event
class ChangeLanguageEvent extends InspectorEvent {
  final Language language;

  const ChangeLanguageEvent(this.language);

  @override
  List<Object?> get props => [language];
}

// Add more global events here:
// class ChangeThemeEvent extends InspectorEvent { ... }
// class ConnectivityChangedEvent extends InspectorEvent { ... }
