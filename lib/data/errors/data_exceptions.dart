sealed class DataException implements Exception {
  const DataException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

class ValidationException extends DataException {
  const ValidationException(super.message, {super.cause});
}

class ConstraintException extends DataException {
  const ConstraintException(super.message, {super.cause});
}

class NotFoundException extends DataException {
  const NotFoundException(super.message, {super.cause});
}

class UnknownDataException extends DataException {
  const UnknownDataException(super.message, {super.cause});
}

