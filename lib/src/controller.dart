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

  emit(T state) {
    if (_last != value) {
      _last = value;
    }
    value = state;
  }
}

/// This widget should be used to reflect changes made to its states.
/// It contains a property called ```controller``` where
/// you must pass the controller that the component needs to use
/// to observe the changes.
class ControllerBuilder<C extends Controller<S>, S extends StateController>
    extends StatelessWidget {
  const ControllerBuilder({
    super.key,
    required this.controller,
    required this.builder,
    this.listenWhen,
    this.builderWhen,
  });

  /// Controller that will be used to detect changes
  final C controller;

  /// Widget that will be built on the screen
  final Widget Function(BuildContext _, S state) builder;

  /// Listen for state change and take some action when condition is true
  final void Function(S before, S after)? listenWhen;

  /// Rebuilds the widget only when the function result is true
  final bool Function(S before, S after)? builderWhen;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<S>(
      valueListenable: controller,
      builder: (_, state, child) {
        if (listenWhen != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            listenWhen!(
              controller.state,
              state,
            );
          });
        }
        if (builderWhen != null) {
          if (builderWhen!(controller.last, state)) {
            return builder(context, state);
          }
          return builder(context, controller.last);
        }
        return builder(context, state);
      },
    );
  }
}

/// This widget should be used to reflect changes made to its states.
/// It recovers the controllers through the injection of dependencies made
/// in the [ControllerProvider]
class ControllerConsumer<C extends Controller<S>, S extends StateController>
    extends StatelessWidget {
  const ControllerConsumer({
    super.key,
    required this.builder,
    this.builderWhen,
    this.listenWhen,
  });

  /// Rebuilds the widget only when the function result is true
  final bool Function(S before, S after)? builderWhen;

  /// Listen for state change and take some action when condition is true
  final void Function(S before, S after)? listenWhen;

  /// Widget that will be built on the screen
  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<S>(
      valueListenable: ControllerProvider.of<C>(context),
      builder: (context, state, child) {
        if (listenWhen != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            listenWhen!(
              ControllerProvider.of<C>(context).state,
              state,
            );
          });
        }

        if (builderWhen != null) {
          if (builderWhen!(
            ControllerProvider.of<C>(context).last,
            state,
          )) {
            return builder(context, state);
          }
          return builder(
            context,
            ControllerProvider.of<C>(context).last,
          );
        }
        return builder(context, state);
      },
    );
  }
}

/// Widget used to do dependency injection
class ControllerProvider extends InheritedWidget {
  ControllerProvider({
    Key? key,
    required Widget child,
    final List<Controller>? controllers,
  }) : super(key: key, child: child) {
    _controllers = controllers;
    _controllersS = _controllers;
  }

  late final List<Controller>? _controllers;
  static List<Controller>? _controllersS;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static T of<T>(BuildContext c) {
    var provider = c.dependOnInheritedWidgetOfExactType<ControllerProvider>();
    if (provider == null) {
      return ControllerProvider._controllersS!.whereType<T>().first;
    }
    return provider._controllers!.whereType<T>().first;
  }
}
