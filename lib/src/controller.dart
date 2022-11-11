import 'package:flutter/widgets.dart';

abstract class Controller<T> extends ValueNotifier<T> {
  Controller(this.state) : super(state);

  final T state;

  emit(T state) {
    value = state;
  }
}

class ControllerBuilder<C extends Controller<S>, S> extends StatelessWidget {
  const ControllerBuilder({
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
        if (builderWhen != null &&
            builderWhen!(
              ControllerProvider.of<C>().state,
              state,
            )) {
          return builder(context, state);
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
