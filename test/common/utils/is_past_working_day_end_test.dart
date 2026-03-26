import 'package:flutter_test/flutter_test.dart';
import 'package:timerevo/common/utils/is_past_working_day_end.dart';
import 'package:timerevo/domain/entities/session_info.dart';

void main() {
  final sessionJan1Morning = SessionInfo(
    id: 1,
    startTs: DateTime(2025, 1, 1, 10, 0).toUtc().millisecondsSinceEpoch,
    status: 'open',
  );

  const endMin = 18 * 60; // 18:00

  test('same calendar day before end is false', () {
    expect(
      isPastWorkingDayEnd(
        sessionJan1Morning,
        endMin,
        now: DateTime(2025, 1, 1, 17, 0),
      ),
      isFalse,
    );
  });

  test('same calendar day at or after end is true', () {
    expect(
      isPastWorkingDayEnd(
        sessionJan1Morning,
        endMin,
        now: DateTime(2025, 1, 1, 18, 0),
      ),
      isTrue,
    );
  });

  test('next calendar day after session date is true', () {
    expect(
      isPastWorkingDayEnd(
        sessionJan1Morning,
        endMin,
        now: DateTime(2025, 1, 2, 0, 0),
      ),
      isTrue,
    );
  });
}
