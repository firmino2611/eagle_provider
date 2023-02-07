import 'package:eagle_provider/src/contracts/controller.dart';
import 'package:eagle_provider/src/contracts/state_controller.dart';
import 'package:eagle_provider/src/controller_provider.dart';
import 'package:flutter/material.dart';

/// A [StatelessWidget] that listens to a [Controller] and calls the [listener]
/// whenever the [listenWhen] condition is met.
///
/// The widget also calls the [builder] whenever the [buildWhen] condition is met
/// and returns the output of the [builder] as its child. If the [buildWhen] condition
/// is not met, it returns the last output of the [builder].

class ControllerConsummer<C extends Controller<S>, S extends StateController>
    extends StatelessWidget {
  const ControllerConsummer({
    super.key,
    this.controller,
    this.listener,
    required this.listenWhen,
    this.buildWhen,
    required this.builder,
  });

  /// [listener] is a callback function that takes a [BuildContext]
  /// and a [StateController] and is called whenever
  /// the [listenWhen] condition is met.
  final void Function(BuildContext context, S state)? listener;

  /// [listenWhen] is a condition that takes two [StateController] instances,
  /// the previous state and the current state, and returns a boolean
  /// indicating whether the [listener] should be called.
  final bool Function(S previous, S current)? listenWhen;

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
        if (listenWhen != null) {
          if (listenWhen!(ctrl.previous, state)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              listener?.call(context, state);
            });
          }
        }
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
