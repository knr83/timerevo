import 'package:flutter_test/flutter_test.dart';
import 'package:timerevo/domain/attendance_interval_resolver.dart';
import 'package:timerevo/domain/entities/schedule_entities.dart';

void main() {
  const firstInterval = ScheduleInterval(startMin: 480, endMin: 780);
  const secondInterval = ScheduleInterval(startMin: 900, endMin: 1020);
  const twoIntervals = [firstInterval, secondInterval];

  group('resolveIntervalForTime', () {
    test('returns null for empty intervals', () {
      expect(resolveIntervalForTime(540, []), isNull);
    });

    test('before first interval (early check-in) returns first', () {
      final result = resolveIntervalForTime(420, twoIntervals);
      expect(result, isNotNull);
      expect(result!.startMin, firstInterval.startMin);
      expect(result.endMin, firstInterval.endMin);
    });

    test('exact start of first interval returns first', () {
      final result = resolveIntervalForTime(480, twoIntervals);
      expect(result, isNotNull);
      expect(result!.startMin, firstInterval.startMin);
    });

    test('inside first interval returns first', () {
      final result = resolveIntervalForTime(540, twoIntervals);
      expect(result, isNotNull);
      expect(result!.startMin, firstInterval.startMin);
    });

    test('exact end of first interval returns first', () {
      final result = resolveIntervalForTime(780, twoIntervals);
      expect(result, isNotNull);
      expect(result!.startMin, firstInterval.startMin);
    });

    test('in gap between intervals returns second', () {
      final result840 = resolveIntervalForTime(840, twoIntervals);
      expect(result840, isNotNull);
      expect(result840!.startMin, secondInterval.startMin);

      final result870 = resolveIntervalForTime(870, twoIntervals);
      expect(result870, isNotNull);
      expect(result870!.startMin, secondInterval.startMin);
    });

    test('exact start of second interval returns second', () {
      final result = resolveIntervalForTime(900, twoIntervals);
      expect(result, isNotNull);
      expect(result!.startMin, secondInterval.startMin);
    });

    test('inside second interval returns second', () {
      final result = resolveIntervalForTime(960, twoIntervals);
      expect(result, isNotNull);
      expect(result!.startMin, secondInterval.startMin);
    });

    test('exact end of second interval returns second', () {
      final result = resolveIntervalForTime(1020, twoIntervals);
      expect(result, isNotNull);
      expect(result!.startMin, secondInterval.startMin);
    });

    test('after last interval returns null', () {
      expect(resolveIntervalForTime(1080, twoIntervals), isNull);
    });

    group('single-interval case', () {
      const singleInterval = ScheduleInterval(startMin: 480, endMin: 780);
      const oneInterval = [singleInterval];

      test('before interval returns first', () {
        final result = resolveIntervalForTime(420, oneInterval);
        expect(result, isNotNull);
        expect(result!.startMin, singleInterval.startMin);
      });

      test('after last interval returns null', () {
        expect(resolveIntervalForTime(1080, oneInterval), isNull);
      });
    });
  });
}
