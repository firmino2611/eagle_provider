import 'package:eagle_provider/eagle_provider.dart';
import 'package:flutter/widgets.dart';

/// The `Controller` class extends [ValueNotifier] and adds a mechanism
/// for tracking changes to its value.
/// It provides the `emit` method to update its value, and notifies
/// listeners when the value changes.
abstract class Controller<S extends StateController> extends ValueNotifier<S> {
  /// Constructor to initialize the state and keep track of the previous value.
  Controller(super.state) {
    _previous = value;
  }

  late S _previous;

  S get previous => _previous;

  /// Method to update the value of the state and notify listeners
  /// if the new value is different from the previous.
  void emit(S state) {
    if (_previous != state) {
      _previous = value;
    }
    value = state;
    onChange(_previous, value);
  }

  /// Method to be implemented by concrete subclasses to respond to
  /// changes in the state.
  void onChange(S? previous, S current);
}
