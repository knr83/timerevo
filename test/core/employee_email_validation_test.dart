import 'package:flutter_test/flutter_test.dart';
import 'package:timerevo/core/employee_email_validation.dart';

void main() {
  group('isWellFormedEmployeeEmail', () {
    test('empty is false', () {
      expect(isWellFormedEmployeeEmail(''), false);
    });
    test('accepts common addresses', () {
      expect(isWellFormedEmployeeEmail('a@b.co'), true);
      expect(isWellFormedEmployeeEmail('user.name+tag@example.com'), true);
      expect(isWellFormedEmployeeEmail('x@sub.example.org'), true);
    });
    test('rejects invalid', () {
      expect(isWellFormedEmployeeEmail('nodomain'), false);
      expect(isWellFormedEmployeeEmail('a@'), false);
      expect(isWellFormedEmployeeEmail('@b.com'), false);
      expect(isWellFormedEmployeeEmail('a @b.com'), false);
      expect(isWellFormedEmployeeEmail('a@b'), false);
    });
  });
}
