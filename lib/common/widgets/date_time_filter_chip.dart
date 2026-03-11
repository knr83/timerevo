import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../utils/date_time_picker.dart';
import '../utils/time_format.dart';

class DateTimeFilterChip extends StatelessWidget {
  const DateTimeFilterChip({
    super.key,
    required this.label,
    required this.valueUtcMs,
    required this.onPickedUtcMs,
    required this.onCleared,
  });

  final String label;
  final int? valueUtcMs;
  final ValueChanged<int> onPickedUtcMs;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final valueStr = valueUtcMs == null
        ? l10n.sessionsFilterAny
        : TimeFormat.formatLocalFromUtcMs(valueUtcMs!);
    final text = l10n.commonFilterLabelWithValue(label, valueStr);

    return InputChip(
      label: Text(text),
      onPressed: () async {
        final picked = await pickLocalDateTime(context);
        if (picked == null) return;
        onPickedUtcMs(picked.toUtc().millisecondsSinceEpoch);
      },
      onDeleted: valueUtcMs == null ? null : onCleared,
    );
  }
}
