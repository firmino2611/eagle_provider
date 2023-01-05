import 'package:eagle_provider/eagle_provider.dart';
import 'package:flutter/widgets.dart';

/// Class responsible for containing the base of the controller,
/// through which we will build our controller,
/// which will always be a state-based type.
///
/// When implementing a controller extending from this one,
/// it will be necessary to pass a valid State.
///
/// The controller class should be used to manipulate the state
abstract class Controller<T extends StateController> extends ValueNotifier<T> {
  Controller(super.value) {
    _last = value;
  }

  late T _last;

  T get state => value;
  T get last => _last;

  emit(T state, [bool delayUpdate = false]) {
    // if (delayUpdate) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if (_last != value) {
      _last = value;
    }
    value = state;
    // });
    // } else {
    //   if (_last != value) {
    //     _last = value;
    //   }
    //   value = state;
    // }
  }
}
