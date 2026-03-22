import 'package:flutter/services.dart';

import '../../core/starting_balance_display.dart';

/// Restricts input to prefixes valid for [parseStartingBalanceTenths].
class StartingBalanceInputFormatter extends TextInputFormatter {
  const StartingBalanceInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (isStartingBalanceInProgressInputAllowed(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
