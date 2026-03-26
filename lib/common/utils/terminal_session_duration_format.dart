import 'package:timerevo/l10n/app_localizations.dart';

/// Minutes between start and end, truncating to minute boundaries.
int minutesBetweenUtcMsClamp(int startUtcMs, int endUtcMs) {
  final startMin = (startUtcMs / 60000).floor();
  final endMin = (endUtcMs / 60000).floor();
  return (endMin - startMin).clamp(0, 999999);
}

/// Terminal session list / dashboard / calendar session row duration labels.
String formatTerminalSessionDuration(AppLocalizations l10n, int totalMin) {
  if (totalMin <= 0) return l10n.terminalDurationLessThanOneMin;
  final h = totalMin ~/ 60;
  final m = totalMin % 60;
  if (h == 0) return l10n.terminalDurationMinutesOnly(m);
  if (m == 0) return l10n.terminalDurationHoursOnly(h);
  return l10n.durationHm(h, m);
}
