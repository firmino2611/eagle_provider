import 'package:eagle_provider/src/controller.dart';
import 'package:flutter/material.dart';

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
