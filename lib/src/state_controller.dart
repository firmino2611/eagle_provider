import 'package:equatable/equatable.dart';

enum Status { initial, loading, success, failure }

abstract class StateController extends Equatable {
  const StateController({this.status = Status.loading});

  final Status status;

  @override
  List<Object?> get props;

  @override
  bool get stringify => true;

  copyWith();
}
