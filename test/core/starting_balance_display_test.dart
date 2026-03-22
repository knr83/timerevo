import 'package:flutter_test/flutter_test.dart';
import 'package:timerevo/core/starting_balance_display.dart';

void main() {
  group('formatStartingBalanceTenthsForDisplay', () {
    test('null is em dash', () {
      expect(formatStartingBalanceTenthsForDisplay(null), '\u2014');
    });
    test('zero is 0.0', () {
      expect(formatStartingBalanceTenthsForDisplay(0), '0.0');
    });
    test('positive one decimal', () {
      expect(formatStartingBalanceTenthsForDisplay(125), '12.5');
    });
    test('negative', () {
      expect(formatStartingBalanceTenthsForDisplay(-37), '-3.7');
    });
  });

  group('parseStartingBalanceTenths', () {
    test('empty unset', () {
      expect(parseStartingBalanceTenths(''), null);
      expect(parseStartingBalanceTenths('  '), null);
    });
    test('integer as x.0', () {
      expect(parseStartingBalanceTenths('12'), 120);
    });
    test('one decimal', () {
      expect(parseStartingBalanceTenths('12.5'), 125);
      expect(parseStartingBalanceTenths('-0.0'), 0);
    });
    test('invalid', () {
      expect(parseStartingBalanceTenths('12.55'), null);
      expect(parseStartingBalanceTenths('abc'), null);
    });
  });

  group('isStartingBalanceInProgressInputAllowed', () {
    test('allows empty and typical prefixes', () {
      expect(isStartingBalanceInProgressInputAllowed(''), true);
      expect(isStartingBalanceInProgressInputAllowed('-'), true);
      expect(isStartingBalanceInProgressInputAllowed('12'), true);
      expect(isStartingBalanceInProgressInputAllowed('12.'), true);
      expect(isStartingBalanceInProgressInputAllowed('.'), true);
      expect(isStartingBalanceInProgressInputAllowed('.5'), true);
      expect(isStartingBalanceInProgressInputAllowed('-0.5'), true);
    });
    test('rejects invalid', () {
      expect(isStartingBalanceInProgressInputAllowed('12.55'), false);
      expect(isStartingBalanceInProgressInputAllowed('1..2'), false);
      expect(isStartingBalanceInProgressInputAllowed('a'), false);
      expect(isStartingBalanceInProgressInputAllowed('1-2'), false);
      expect(isStartingBalanceInProgressInputAllowed(' '), false);
    });
  });

  group('isStartingBalanceInputIncompleteForErrorDisplay', () {
    test('incomplete markers', () {
      expect(isStartingBalanceInputIncompleteForErrorDisplay(''), false);
      expect(isStartingBalanceInputIncompleteForErrorDisplay('-'), true);
      expect(isStartingBalanceInputIncompleteForErrorDisplay('12.'), true);
      expect(isStartingBalanceInputIncompleteForErrorDisplay('.'), true);
    });
    test('complete trimmed input', () {
      expect(isStartingBalanceInputIncompleteForErrorDisplay('12'), false);
      expect(isStartingBalanceInputIncompleteForErrorDisplay('12.5'), false);
    });
  });
}
