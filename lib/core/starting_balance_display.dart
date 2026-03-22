/// Display [tenths] as unset (`—`), explicit zero (`0.0`), or signed `x.x` (one decimal).
String formatStartingBalanceTenthsForDisplay(int? tenths) {
  if (tenths == null) {
    return '\u2014';
  }
  if (tenths == 0) {
    return '0.0';
  }
  final sign = tenths < 0 ? '-' : '';
  final abs = tenths.abs();
  final w = abs ~/ 10;
  final f = abs % 10;
  return '$sign$w.$f';
}

/// Parses trimmed user input: empty → unset (`null`); otherwise one decimal place, optional leading `-`.
/// Integer input `12` is treated as `12.0`. Returns `null` if invalid.
int? parseStartingBalanceTenths(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return null;
  final neg = t.startsWith('-');
  final s0 = neg ? t.substring(1).trim() : t;
  if (s0.isEmpty) return null;
  final dot = s0.indexOf('.');
  final String wholeStr;
  final String fracStr;
  if (dot < 0) {
    wholeStr = s0;
    fracStr = '0';
  } else {
    if (s0.indexOf('.', dot + 1) >= 0) return null;
    wholeStr = s0.substring(0, dot);
    fracStr = s0.substring(dot + 1);
  }
  if (fracStr.length != 1) return null;
  final fd = int.tryParse(fracStr);
  if (fd == null || fd < 0 || fd > 9) return null;
  final wi = wholeStr.isEmpty ? 0 : int.tryParse(wholeStr);
  if (wi == null) return null;
  var tenths = wi * 10 + fd;
  if (neg) tenths = -tenths;
  return tenths;
}

/// True while the user may still be typing (e.g. lone `-` or trailing `.`).
/// Empty trimmed input is not treated as incomplete (unset field).
bool isStartingBalanceInputIncompleteForErrorDisplay(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return false;
  if (t == '-') return true;
  if (t.endsWith('.')) return true;
  return false;
}

/// Allowed structure for live keyboard/paste input: optional leading `-`, digits,
/// at most one `.`, and at most one digit after `.`. Empty is allowed.
bool isStartingBalanceInProgressInputAllowed(String value) {
  if (value.isEmpty) return true;
  var i = 0;
  if (value.codeUnitAt(0) == 0x2d) {
    if (value.length == 1) return true;
    i = 1;
  }
  var dotSeen = false;
  var digitsAfterDot = 0;
  for (; i < value.length; i++) {
    final u = value.codeUnitAt(i);
    if (u >= 0x30 && u <= 0x39) {
      if (dotSeen) {
        digitsAfterDot++;
        if (digitsAfterDot > 1) return false;
      }
      continue;
    }
    if (u == 0x2e) {
      if (dotSeen) return false;
      dotSeen = true;
      continue;
    }
    return false;
  }
  return true;
}
