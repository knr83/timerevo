import 'package:flutter_test/flutter_test.dart';
import 'package:timerevo/domain/entities/schedule_entities.dart';
import 'package:timerevo/domain/report_norm_calculator.dart';

void main() {
  group('intervalDurationMinutes', () {
    test('returns difference when endMin > startMin (540–1020 → 480)', () {
      const i = ScheduleInterval(startMin: 540, endMin: 1020);
      expect(ReportNormCalculator.intervalDurationMinutes(i), 480);
    });

    test('returns 0 when endMin <= startMin', () {
      const i1 = ScheduleInterval(startMin: 600, endMin: 600);
      const i2 = ScheduleInterval(startMin: 720, endMin: 480);
      expect(ReportNormCalculator.intervalDurationMinutes(i1), 0);
      expect(ReportNormCalculator.intervalDurationMinutes(i2), 0);
    });
  });

  group('dayNormMinutes', () {
    test('returns 0 when day off', () {
      const s = ResolvedSchedule(
        source: 'template',
        isDayOff: true,
        intervals: [],
      );
      expect(ReportNormCalculator.dayNormMinutes(s, false), 0);
    });

    test('returns 0 when approved absence', () {
      const s = ResolvedSchedule(
        source: 'template',
        isDayOff: false,
        intervals: [ScheduleInterval(startMin: 540, endMin: 1020)],
      );
      expect(ReportNormCalculator.dayNormMinutes(s, true), 0);
    });

    test('returns 0 when intervals empty (no approved absence)', () {
      const s = ResolvedSchedule(
        source: 'template',
        isDayOff: false,
        intervals: [],
      );
      expect(ReportNormCalculator.dayNormMinutes(s, false), 0);
    });

    test('returns correct minutes for single interval', () {
      const s = ResolvedSchedule(
        source: 'template',
        isDayOff: false,
        intervals: [ScheduleInterval(startMin: 540, endMin: 1020)],
      );
      expect(ReportNormCalculator.dayNormMinutes(s, false), 480);
    });

    test('returns sum for multiple intervals', () {
      const s = ResolvedSchedule(
        source: 'template',
        isDayOff: false,
        intervals: [
          ScheduleInterval(startMin: 540, endMin: 720),
          ScheduleInterval(startMin: 780, endMin: 1020),
        ],
      );
      expect(ReportNormCalculator.dayNormMinutes(s, false), 180 + 240);
    });

    test('ignores invalid intervals (endMin <= startMin)', () {
      const s = ResolvedSchedule(
        source: 'template',
        isDayOff: false,
        intervals: [
          ScheduleInterval(startMin: 540, endMin: 1020),
          ScheduleInterval(startMin: 600, endMin: 600),
        ],
      );
      expect(ReportNormCalculator.dayNormMinutes(s, false), 480);
    });
  });
}
