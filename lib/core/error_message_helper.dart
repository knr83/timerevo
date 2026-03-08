/// Maps exceptions to user-visible messages. Never leaks raw exception details.
///
/// Use [genericFallback] (e.g. l10n.commonErrorOccurred) for all errors in
/// generic handlers. For specific flows (e.g. absence request), catch
/// [DomainValidationException] and map known keys to l10n explicitly.
String errorMessageForUser(Object error, String genericFallback) {
  return genericFallback;
}
