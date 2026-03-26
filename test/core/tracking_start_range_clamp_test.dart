import 'package:flutter_test/flutter_test.dart';
import 'package:timerevo/core/tracking_start_range_clamp.dart';

void main() {
  group('clampUtcRangeToTrackingStart', () {
    test('null or empty tracking leaves range unchanged', () {
      final a = clampUtcRangeToTrackingStart(
        fromUtcMs: 100,
        toUtcMs: 200,
        trackingStartYmd: null,
      );
      expect(a.fromUtcMs, 100);
      expect(a.toUtcMs, 200);

      final b = clampUtcRangeToTrackingStart(
        fromUtcMs: 100,
        toUtcMs: 200,
        trackingStartYmd: '',
      );
      expect(b.fromUtcMs, 100);
      expect(b.toUtcMs, 200);
    });

    test('raises from when it is before tracking local day start', () {
      final bound = trackingStartLocalDayStartUtcMsFromYmd('2024-06-15');
      final r = clampUtcRangeToTrackingStart(
        fromUtcMs: bound - 1,
        toUtcMs: bound + 999999,
        trackingStartYmd: '2024-06-15',
      );
      expect(r.fromUtcMs, bound);
      expect(r.toUtcMs, bound + 999999);
    });

    test('does not lower toUtcMs when range stays valid', () {
      final bound = trackingStartLocalDayStartUtcMsFromYmd('2030-01-01');
      const toLate = 4000000000000; // must be > bound so upper end is unchanged
      final r = clampUtcRangeToTrackingStart(
        fromUtcMs: 0,
        toUtcMs: toLate,
        trackingStartYmd: '2030-01-01',
      );
      expect(r.fromUtcMs, bound);
      expect(r.toUtcMs, toLate);
    });

    test('when clamped from exceeds to, raises to to match from', () {
      const toEarly = 100;
      final bound = trackingStartLocalDayStartUtcMsFromYmd('2024-06-15');
      final r = clampUtcRangeToTrackingStart(
        fromUtcMs: 50,
        toUtcMs: toEarly,
        trackingStartYmd: '2024-06-15',
      );
      expect(r.fromUtcMs, bound);
      expect(r.toUtcMs, bound);
    });

    test('from after bound unchanged', () {
      final bound = trackingStartLocalDayStartUtcMsFromYmd('2024-01-01');
      final r = clampUtcRangeToTrackingStart(
        fromUtcMs: bound + 1000,
        toUtcMs: bound + 2000,
        trackingStartYmd: '2024-01-01',
      );
      expect(r.fromUtcMs, bound + 1000);
      expect(r.toUtcMs, bound + 2000);
    });
  });

  group('maybeClampCustomUtcRange', () {
    test('returns null when either bound is null', () {
      expect(
        maybeClampCustomUtcRange(
          fromUtcMs: null,
          toUtcMs: 200,
          trackingStartYmd: '2024-01-01',
        ),
        isNull,
      );
      expect(
        maybeClampCustomUtcRange(
          fromUtcMs: 100,
          toUtcMs: null,
          trackingStartYmd: '2024-01-01',
        ),
        isNull,
      );
    });

    test('returns null when clamp equals inputs', () {
      expect(
        maybeClampCustomUtcRange(
          fromUtcMs: 100,
          toUtcMs: 200,
          trackingStartYmd: null,
        ),
        isNull,
      );
    });
  });

  group('maybeClampUtcRangeIfUpdateNeeded', () {
    test('returns null when clamped equals stored', () {
      final bound = trackingStartLocalDayStartUtcMsFromYmd('2024-06-15');
      final r = clampUtcRangeToTrackingStart(
        fromUtcMs: bound - 1,
        toUtcMs: bound + 100,
        trackingStartYmd: '2024-06-15',
      );
      expect(
        maybeClampUtcRangeIfUpdateNeeded(
          resolvedFromUtcMs: bound - 1,
          resolvedToUtcMs: bound + 100,
          storedFromUtcMs: r.fromUtcMs,
          storedToUtcMs: r.toUtcMs,
          trackingStartYmd: '2024-06-15',
        ),
        isNull,
      );
    });

    test('returns clamp when stored differs from clamped', () {
      final bound = trackingStartLocalDayStartUtcMsFromYmd('2024-06-15');
      final c = maybeClampUtcRangeIfUpdateNeeded(
        resolvedFromUtcMs: bound - 1,
        resolvedToUtcMs: bound + 100,
        storedFromUtcMs: bound - 1,
        storedToUtcMs: bound + 100,
        trackingStartYmd: '2024-06-15',
      );
      expect(c, isNotNull);
      expect(c!.fromUtcMs, bound);
    });
  });

  group('trackingStartLocalDayStartUtcMsFromYmd', () {
    test('parses YYYY-MM-DD', () {
      final ms = trackingStartLocalDayStartUtcMsFromYmd('2024-03-10');
      expect(ms, isPositive);
    });

    test('invalid format throws', () {
      expect(
        () => trackingStartLocalDayStartUtcMsFromYmd('bad'),
        throwsFormatException,
      );
    });
  });

  group('clampAbsenceFromDateYmd', () {
    test('no tracking returns fromDate', () {
      expect(clampAbsenceFromDateYmd('2024-01-01', null), '2024-01-01');
      expect(clampAbsenceFromDateYmd('2024-01-01', ''), '2024-01-01');
    });

    test('uses max of ISO dates', () {
      expect(clampAbsenceFromDateYmd('2024-01-01', '2024-06-01'), '2024-06-01');
      expect(clampAbsenceFromDateYmd('2024-08-01', '2024-06-01'), '2024-08-01');
    });
  });
}
