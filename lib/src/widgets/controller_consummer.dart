import 'package:eagle_provider/src/controller.dart';
import 'package:eagle_provider/src/controller_provider.dart';
import 'package:eagle_provider/src/state_controller.dart';
import 'package:flutter/material.dart';

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
    this.listener,
  });

  /// Rebuilds the widget only when the function result is true
  final bool Function(S before, S after)? builderWhen;

  /// Condition for some action to be performed after
  /// the condition is satisfied
  final bool Function(S before, S after)? listenWhen;

  /// Execute some function when [listenWhen] returns true
  final void Function(S before, S after)? listener;

  /// Widget that will be built on the screen
  final Widget Function(BuildContext context, S state) builder;

  @override
  State<ControllerConsumer> createState() => ControllerConsumerState<C, S>();
}

class ControllerConsumerState<C extends Controller<S>,
    S extends StateController> extends State<ControllerConsumer<C, S>> {
  late Widget _lastBuilder;

  @override
  Widget build(BuildContext context) {
    var controller = ControllerProvider.of<C>(context);

    _lastBuilder = widget.builder(
      context,
      controller.state,
    );

    return ValueListenableBuilder<S>(
      valueListenable: controller,
      builder: (context, state, child) {
        if (widget.listenWhen != null) {
          if (widget.listenWhen!(controller.state, state)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.listener!(
                controller.state,
                state,
              );
            });
          }
        }

        if (widget.builderWhen != null) {
          if (widget.builderWhen!(controller.last, state)) {
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
