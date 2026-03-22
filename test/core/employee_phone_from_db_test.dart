import 'package:flutter_test/flutter_test.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:timerevo/core/employee_phone_from_db.dart';

void main() {
  group('normalizeAppLanguageCode', () {
    test('keeps de ru en', () {
      expect(normalizeAppLanguageCode('DE'), 'de');
      expect(normalizeAppLanguageCode('ru'), 'ru');
      expect(normalizeAppLanguageCode('en'), 'en');
    });
    test('unknown falls back to de', () {
      expect(normalizeAppLanguageCode('fr'), 'de');
      expect(normalizeAppLanguageCode('xx'), 'de');
    });
  });

  group('isoCodeForLocaleLanguage', () {
    test('maps supported languages', () {
      expect(isoCodeForLocaleLanguage('de'), IsoCode.DE);
      expect(isoCodeForLocaleLanguage('ru'), IsoCode.RU);
      expect(isoCodeForLocaleLanguage('en'), IsoCode.US);
    });
    test('defaults unknown to DE', () {
      expect(isoCodeForLocaleLanguage('xx'), IsoCode.DE);
    });
  });

  group('phoneNumberFromDbString', () {
    const de = IsoCode.DE;
    test('empty', () {
      final p = phoneNumberFromDbString(null, defaultIso: de);
      expect(p.nsn, '');
      expect(p.isoCode, de);
    });
    test('international', () {
      final p = phoneNumberFromDbString('+4930123456', defaultIso: de);
      expect(p.international, '+4930123456');
    });
    test('legacy unparsable preserves nsn', () {
      final p = phoneNumberFromDbString('not-a-phone', defaultIso: de);
      expect(p.isoCode, de);
      expect(p.nsn, 'not-a-phone');
    });
  });

  group('phoneNumberToDbString', () {
    test('empty nsn to null', () {
      expect(
        phoneNumberToDbString(const PhoneNumber(isoCode: IsoCode.DE, nsn: '')),
        null,
      );
    });
    test('non-empty to international', () {
      final p = phoneNumberFromDbString('+14155552671', defaultIso: IsoCode.US);
      expect(phoneNumberToDbString(p), isNotNull);
      expect(phoneNumberToDbString(p), startsWith('+'));
    });
  });

  group('isPhoneFieldAcceptable', () {
    test('empty ok', () {
      expect(
        isPhoneFieldAcceptable(const PhoneNumber(isoCode: IsoCode.DE, nsn: '')),
        true,
      );
    });
  });
}
