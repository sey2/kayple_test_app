import 'result.dart';

extension ResultX<T> on Result<T> {
  R when<R>({
    required R Function(T data) ok,
    required R Function(Exception exception) failure,
  }) {
    return switch (this) {
      Ok(:final value) => ok(value),
      Failure(:final error) => failure(error),
    };
  }
}
