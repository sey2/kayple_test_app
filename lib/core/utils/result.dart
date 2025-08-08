sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok._;
  const factory Result.failure(Exception error) = Failure._;
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure._(this.error);

  final Exception error;
}
