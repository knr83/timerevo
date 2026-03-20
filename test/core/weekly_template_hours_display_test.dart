import 'package:flutter_test/flutter_test.dart';
import 'package:timerevo/core/weekly_template_hours_display.dart';

void main() {
  const emDash = '\u2014';

  test('null returns em dash', () {
    expect(formatTemplateWeeklyHoursDisplay(null), emDash);
  });

  test('normative examples', () {
    expect(formatTemplateWeeklyHoursDisplay(2400), '40');
    expect(formatTemplateWeeklyHoursDisplay(2370), '39.5');
  });

  test('zero minutes', () {
    expect(formatTemplateWeeklyHoursDisplay(0), '0');
  });

  test('half-up to one decimal (6 min = 0.1 h)', () {
    expect(formatTemplateWeeklyHoursDisplay(3), '0.1');
    expect(formatTemplateWeeklyHoursDisplay(6), '0.1');
  });

  test('2380 min rounds to 39.7', () {
    expect(formatTemplateWeeklyHoursDisplay(2380), '39.7');
  });

  test('negative minutes throws', () {
    expect(() => formatTemplateWeeklyHoursDisplay(-1), throwsArgumentError);
  });
}
