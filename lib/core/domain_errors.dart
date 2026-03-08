/// Domain-level exceptions. UI catches these; data layer maps DataException → these.
sealed class DomainException implements Exception {
  const DomainException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

class DomainValidationException extends DomainException {
  const DomainValidationException(super.message, {super.cause});
}

class DomainConstraintException extends DomainException {
  const DomainConstraintException(super.message, {super.cause});
}

class DomainNotFoundException extends DomainException {
  const DomainNotFoundException(super.message, {super.cause});
}

class DomainUnknownException extends DomainException {
  const DomainUnknownException(super.message, {super.cause});
}
