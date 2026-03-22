/// Pragmatic single-address check (ASCII local part + domain with TLD).
/// Call only with already-trimmed [value]; empty string is invalid here (use call site for optional empty).
bool isWellFormedEmployeeEmail(String value) {
  if (value.isEmpty) return false;
  return _employeeEmailAsciiRegExp.hasMatch(value);
}

// Local: letters, digits, common specials; domain: labels + dot + TLD 2+ letters.
final RegExp _employeeEmailAsciiRegExp = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$',
);
