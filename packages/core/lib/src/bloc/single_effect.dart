/// Wrapper for single-use effects in BLoC state
/// Ensures an effect is only handled once by the UI
class SingleEffect<T> {
  final T _value;
  bool _hasBeenHandled = false;

  SingleEffect(this._value);

  /// Returns the effect value if not yet handled, null otherwise
  /// Marks the effect as handled after first access
  T? get current {
    if (_hasBeenHandled) return null;
    _hasBeenHandled = true;
    return _value;
  }

  /// Returns the value without consuming it
  T get peek => _value;

  /// Check if effect has been handled
  bool get isHandled => _hasBeenHandled;
}
