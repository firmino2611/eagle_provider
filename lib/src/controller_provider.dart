import 'package:flutter/material.dart';

/// A widget that provides a [Controller] to its descendants.
class ControllerProvider<T> extends InheritedWidget {
  final List<T> controllers;

  /// Creates a [ControllerProvider].
  const ControllerProvider({
    Key? key,
    required this.controllers,
    required Widget child,
  }) : super(key: key, child: child);

  /// Retrieve a [Controller] from a [BuildContext].
  static T? of<T>(BuildContext context) {
    final ControllerProvider<T>? provider =
        context.dependOnInheritedWidgetOfExactType<ControllerProvider<T>>();

    if (provider == null) return null;
    final T? controller = provider.controllers.whereType<T>().first;

    return controller;
  }

  /// Determines whether the [InheritedWidget] should be rebuilt.
  @override
  bool updateShouldNotify(ControllerProvider oldWidget) =>
      controllers != oldWidget.controllers;
}
