base class BaseState {
  BaseState({this.state = StateEnum.initial, this.errorMessage});

  StateEnum state;
  String? errorMessage;
}

enum StateEnum { initial, loading, error, success }
