import 'package:sqlite3/sqlite3.dart' show SqliteException;

import '../../core/domain_errors.dart';
import '../errors/data_exceptions.dart';

DomainException _toDomain(DataException e) {
  return switch (e) {
    ValidationException() => DomainValidationException(
      e.message,
      cause: e.cause,
    ),
    ConstraintException() => DomainConstraintException(
      e.message,
      cause: e.cause,
    ),
    NotFoundException() => DomainNotFoundException(e.message, cause: e.cause),
    UnknownDataException() => DomainUnknownException(e.message, cause: e.cause),
  };
}

Future<T> guardRepoCall<T>(Future<T> Function() body) async {
  try {
    return await body();
  } on DomainException {
    rethrow;
  } on DataException catch (e) {
    throw _toDomain(e);
  } on SqliteException catch (e) {
    throw DomainConstraintException(e.message, cause: e);
  } catch (e) {
    throw DomainUnknownException(e.toString(), cause: e);
  }
}
