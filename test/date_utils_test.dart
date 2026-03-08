import 'package:flutter_test/flutter_test.dart';

import 'package:timerevo/common/utils/date_utils.dart';

void main() {
  group('isSameLocalCalendarDay', () {
    test('returns true when timestamps are equal', () {
      final t = DateTime.utc(2024, 6, 15, 12, 0).millisecondsSinceEpoch;
      expect(isSameLocalCalendarDay(t, t), isTrue);
    });

    test('returns true for same local day (1 hour apart)', () {
      final t1 = DateTime.utc(2024, 6, 15, 12, 0).millisecondsSinceEpoch;
      final t2 = DateTime.utc(2024, 6, 15, 13, 0).millisecondsSinceEpoch;
      expect(isSameLocalCalendarDay(t1, t2), isTrue);
    });

    test('returns false for 25 hours apart', () {
      final t1 = DateTime.utc(2024, 6, 15, 12, 0).millisecondsSinceEpoch;
      final t2 = DateTime.utc(2024, 6, 16, 13, 0).millisecondsSinceEpoch;
      expect(isSameLocalCalendarDay(t1, t2), isFalse);
    });
  });
}
