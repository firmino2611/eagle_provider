enum Status { loading, success, failure }

abstract class StateController {
  StateController({this.status = Status.loading});
  final Status status;

  copyWith();
}
