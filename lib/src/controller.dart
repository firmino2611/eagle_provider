import 'package:eagle_provider/eagle_provider.dart';
import 'package:flutter/widgets.dart';

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

class ControlerBuilder<C extends Controller<S>, S extends StateController>
    extends StatelessWidget {
  const ControlerBuilder({
    super.key,
    required this.controller,
    required this.builder,
    this.builderWhen,
  });

  final C controller;
  final Widget Function(BuildContext, S) builder;
  final bool Function(S before, S after)? builderWhen;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<S>(
      valueListenable: controller,
      builder: (_, state, child) {
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

class ControllerConsumer<C extends Controller<S>, S extends StateController>
    extends StatelessWidget {
  const ControllerConsumer({
    super.key,
    required this.builder,
    this.builderWhen,
    this.listenWhen,
  });

  final bool Function(S before, S after)? builderWhen;
  final void Function(S before, S after)? listenWhen;
  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<S>(
      valueListenable: ControllerProvider.of<C>(),
      builder: (context, state, child) {
        if (listenWhen != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            listenWhen!(
              ControllerProvider.of<C>().state,
              state,
            );
          });
        }
        if (builderWhen != null) {
          if (builderWhen!(ControllerProvider.of<C>().last, state)) {
            return builder(context, state);
          }
          return builder(context, ControllerProvider.of<C>().last);
        }
        return builder(context, state);
      },
    );
  }
}

class ControllerProvider extends InheritedWidget {
  ControllerProvider({
    Key? key,
    required Widget child,
    List<Controller>? controllers,
  }) : super(key: key, child: child) {
    _controllers = controllers;
  }

  static List<Controller>? _controllers;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static T of<T>() {
    return _controllers!.whereType<T>().first;
  }
}
