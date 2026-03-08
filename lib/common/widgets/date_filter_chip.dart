import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/date_time_picker.dart';
import '../utils/date_utils.dart';

/// Date-only filter chip. Picks a calendar date.
/// [useEndOfDay]: if true, stores end of picked day (for To filter); else start of day (for From).
class DateFilterChip extends StatelessWidget {
  const DateFilterChip({
    super.key,
    required this.label,
    required this.valueUtcMs,
    required this.anyLabel,
    required this.onPickedUtcMs,
    required this.onCleared,
    this.useEndOfDay = false,
  });

  final String label;
  final int? valueUtcMs;
  final String anyLabel;
  final ValueChanged<int> onPickedUtcMs;
  final VoidCallback onCleared;
  final bool useEndOfDay;

  @override
  Widget build(BuildContext context) {
    final valueStr = valueUtcMs == null
        ? anyLabel
        : DateFormat('yyyy-MM-dd').format(
            DateTime.fromMillisecondsSinceEpoch(valueUtcMs!, isUtc: true)
                .toLocal(),
          );
    final text = '$label: $valueStr';

    return InputChip(
      label: Text(text),
      onPressed: () async {
        DateTime? initial;
        if (valueUtcMs != null) {
          initial = DateTime.fromMillisecondsSinceEpoch(valueUtcMs!, isUtc: true)
              .toLocal();
          initial = DateTime(initial.year, initial.month, initial.day);
        }
        final date = await pickLocalDateOnly(context, initialDate: initial);
        if (date == null || !context.mounted) return;
        final range = localDayRangeUtcMs(date);
        onPickedUtcMs(useEndOfDay ? range.toUtcMs : range.fromUtcMs);
      },
      onDeleted: valueUtcMs == null ? null : onCleared,
    );
  }
}
