import 'package:eagle_provider/src/contracts/controller.dart';
import 'package:eagle_provider/src/contracts/state_controller.dart';
import 'package:eagle_provider/src/controller_provider.dart';
import 'package:flutter/material.dart';

/// The widget also calls the [builder] whenever the [buildWhen] condition is met
/// and returns the output of the [builder] as its child. If the [buildWhen] condition
/// is not met, it returns the last output of the [builder].
class ControllerBuilder<C extends Controller<S>, S extends StateController>
    extends StatelessWidget {
  const ControllerBuilder({
    super.key,
    this.controller,
    this.buildWhen,
    required this.builder,
  });

  /// [buildWhen] is a condition that takes two [StateController] instances,
  /// the previous state and the current state, and returns a boolean
  /// indicating whether the [builder] should be called.
  final bool Function(S previous, S current)? buildWhen;

  /// [builder] is a callback function that takes a [BuildContext]
  /// and a [StateController] and returns a [Widget].
  /// It is called whenever the [buildWhen] condition is met.
  final Widget Function(BuildContext context, S state) builder;

  /// [controller] is the instance of the [Controller] that this widget should listen to.
  /// If the [controller] is not provided, it tries to find it
  /// using the [ControllerProvider.of] method.
  final C? controller;

  @override
  Widget build(BuildContext context) {
    final ctrl = controller ?? ControllerProvider.of<C>(context)!;

    var lastBuilder = builder(context, ctrl.value);

    return ValueListenableBuilder<S>(
      valueListenable: ctrl,
      builder: (context, state, child) {
        if (buildWhen != null) {
          if (buildWhen!(ctrl.previous, state)) {
            lastBuilder = builder(context, state);
            return builder(context, state);
          }

          return lastBuilder;
        }

        return lastBuilder;
      },
    );
  }
}
