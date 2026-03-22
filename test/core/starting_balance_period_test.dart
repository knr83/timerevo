import 'package:flutter_test/flutter_test.dart';
import 'package:timerevo/core/starting_balance_period.dart';

void main() {
  group('effectiveStartingBalanceYmd', () {
    test('tracking wins when set', () {
      expect(
        effectiveStartingBalanceYmd(
          trackingStartYmd: '2024-01-15',
          balanceUpdatedAtUtcMs: 1,
        ),
        '2024-01-15',
      );
    });
    test('no tracking and no updated at', () {
      expect(
        effectiveStartingBalanceYmd(
          trackingStartYmd: null,
          balanceUpdatedAtUtcMs: null,
        ),
        null,
      );
    });
  });

  group('startingBalanceMsForPeriod', () {
    test('unset tenths', () {
      expect(
        startingBalanceMsForPeriod(
          tenths: null,
          trackingStartYmd: '2020-01-01',
          balanceUpdatedAtUtcMs: 1,
          fromUtcMs: 0,
          toUtcMs: 9999999999999,
        ),
        0,
      );
    });
  });
}
