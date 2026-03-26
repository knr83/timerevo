import 'package:timerevo/l10n/app_localizations.dart';

/// Wall-clock duration from milliseconds: floor to whole minutes, then
/// [AppLocalizations.durationHm] (hours and minutes).
String formatDurationHmFromMs(int ms, AppLocalizations l10n) {
  final totalMinutes = (ms / 60000).floor();
  final h = totalMinutes ~/ 60;
  final m = totalMinutes % 60;
  return l10n.durationHm(h, m);
}
