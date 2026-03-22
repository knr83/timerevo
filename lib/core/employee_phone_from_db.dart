import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// Normalizes [languageCode] to `de|ru|en` (same rule as MaterialApp locale resolution).
String normalizeAppLanguageCode(String languageCode) {
  final code = languageCode.toLowerCase();
  if (code == 'de' || code == 'ru' || code == 'en') {
    return code;
  }
  return 'de';
}

/// Maps app UI locale to a default [IsoCode] for national numbers without a `+` prefix.
IsoCode isoCodeForLocaleLanguage(String normalizedLanguageCode) {
  switch (normalizedLanguageCode.toLowerCase()) {
    case 'de':
      return IsoCode.DE;
    case 'ru':
      return IsoCode.RU;
    case 'en':
      return IsoCode.US;
    default:
      return IsoCode.DE;
  }
}

/// Converts a stored DB string into a [PhoneNumber] for [PhoneController].
/// Legacy free-text values that cannot be parsed are preserved as [nsn] with
/// [defaultIso] so nothing is silently dropped.
PhoneNumber phoneNumberFromDbString(
  String? raw, {
  required IsoCode defaultIso,
}) {
  final t = raw?.trim() ?? '';
  if (t.isEmpty) {
    return PhoneNumber(isoCode: defaultIso, nsn: '');
  }
  try {
    final parsed = t.startsWith('+')
        ? PhoneNumber.parse(t)
        : PhoneNumber.parse(t, destinationCountry: defaultIso);
    // Parser may swallow invalid legacy text without throwing; keep raw nsn.
    if (t.isNotEmpty && parsed.nsn.trim().isEmpty) {
      return PhoneNumber(isoCode: defaultIso, nsn: t);
    }
    return parsed;
  } on PhoneNumberException {
    return PhoneNumber(isoCode: defaultIso, nsn: t);
  }
}

/// `null` when empty; otherwise international `+…` form for SQLite TEXT.
String? phoneNumberToDbString(PhoneNumber value) {
  if (value.nsn.trim().isEmpty) return null;
  return value.international;
}

/// Optional field: empty is OK; non-empty must be valid for the selected country.
bool isPhoneFieldAcceptable(PhoneNumber value) {
  if (value.nsn.trim().isEmpty) return true;
  return value.isValid();
}
