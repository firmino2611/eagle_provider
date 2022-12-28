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
    extends StatefulWidget {
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
  State<ControllerBuilder> createState() => _ControllerBuilderState<C, S>();
}

class _ControllerBuilderState<C extends Controller<S>,
    S extends StateController> extends State<ControllerBuilder<C, S>> {
  late Widget _lastBuilder;

  @override
  Widget build(BuildContext context) {
    _lastBuilder = widget.builder(
      context,
      ControllerProvider.of<C>(context).state,
    );
    return ValueListenableBuilder<S>(
      valueListenable: widget.controller,
      builder: (_, state, child) {
        if (widget.listenWhen != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.listenWhen!(
              widget.controller.state,
              state,
            );
          });
        }
        if (widget.builderWhen != null) {
          if (widget.builderWhen!(widget.controller.last, state)) {
            _lastBuilder = widget.builder(context, state);
            return widget.builder(context, state);
          }

          return _lastBuilder;
        }
        _lastBuilder = widget.builder(context, state);
        return widget.builder(context, state);
      },
    );
  }
}

/// This widget should be used to reflect changes made to its states.
/// It recovers the controllers through the injection of dependencies made
/// in the [ControllerProvider]

class ControllerConsumer<C extends Controller<S>, S extends StateController>
    extends StatefulWidget {
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
  State<ControllerConsumer> createState() => _ControllerConsumerState<C, S>();
}

class _ControllerConsumerState<C extends Controller<S>,
    S extends StateController> extends State<ControllerConsumer<C, S>> {
  late Widget _lastBuilder;

  @override
  Widget build(BuildContext context) {
    _lastBuilder = widget.builder(
      context,
      ControllerProvider.of<C>(context).state,
    );

    return ValueListenableBuilder<S>(
      valueListenable: ControllerProvider.of<C>(context),
      builder: (context, state, child) {
        if (widget.listenWhen != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.listenWhen!(
              ControllerProvider.of<C>(context).state,
              state,
            );
          });
        }

        if (widget.builderWhen != null) {
          if (widget.builderWhen!(
            ControllerProvider.of<C>(context).last,
            state,
          )) {
            _lastBuilder = widget.builder(context, state);
            return widget.builder(context, state);
          }
          return _lastBuilder;
        }
        _lastBuilder = widget.builder(context, state);
        return widget.builder(context, state);
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
