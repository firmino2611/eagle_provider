import 'package:equatable/equatable.dart';

/// Status control
enum Status { initial, loading, success, failure }

/// Contract class for the state. Here you should have
/// the variables that will be used to control the iterations in the UI
abstract class StateController extends Equatable {
  const StateController({this.status = Status.loading});

  /// Controls state status
  final Status status;

  @override
  List<Object?> get props;

  @override
  bool get stringify => true;

  /// method used to clone the current state and
  /// retrieve a new instance with updated values
  Object copyWith();
}
