import 'package:eagle_provider/src/controller.dart';
import 'package:eagle_provider/src/state_controller.dart';
import 'package:flutter/material.dart';

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
    this.builderWhen,
  });

  /// Controller that will be used to detect changes
  final C controller;

  /// Widget that will be built on the screen
  final Widget Function(BuildContext _, S state) builder;

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
      widget.controller.state,
    );
    return ValueListenableBuilder<S>(
      valueListenable: widget.controller,
      builder: (_, state, child) {
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
