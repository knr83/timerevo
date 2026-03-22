import 'package:flutter_test/flutter_test.dart';
import 'package:timerevo/core/weekly_template_hours_display.dart';

void main() {
  const emDash = '\u2014';
  const u = ' h';

  test('null returns em dash', () {
    expect(formatTemplateWeeklyHoursDisplay(null, unitSuffix: u), emDash);
  });

  test('normative examples', () {
    expect(formatTemplateWeeklyHoursDisplay(2400, unitSuffix: u), '40.0 h');
    expect(formatTemplateWeeklyHoursDisplay(2370, unitSuffix: u), '39.5 h');
  });

  test('zero minutes', () {
    expect(formatTemplateWeeklyHoursDisplay(0, unitSuffix: u), '0.0 h');
  });

  test('half-up to one decimal (6 min = 0.1 h)', () {
    expect(formatTemplateWeeklyHoursDisplay(3, unitSuffix: u), '0.1 h');
    expect(formatTemplateWeeklyHoursDisplay(6, unitSuffix: u), '0.1 h');
  });

  test('2380 min rounds to 39.7', () {
    expect(formatTemplateWeeklyHoursDisplay(2380, unitSuffix: u), '39.7 h');
  });

  test('Russian unit suffix', () {
    expect(formatTemplateWeeklyHoursDisplay(2370, unitSuffix: ' ч'), '39.5 ч');
  });

  test('negative minutes throws', () {
    expect(
      () => formatTemplateWeeklyHoursDisplay(-1, unitSuffix: u),
      throwsArgumentError,
    );
  });
}
