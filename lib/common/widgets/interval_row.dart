import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../domain/entities/schedule_entities.dart';
import '../utils/time_format.dart';

class IntervalRow extends StatelessWidget {
  const IntervalRow.decorated({
    super.key,
    required this.interval,
    required this.onChanged,
    required this.onDelete,
  }) : decorated = true;

  const IntervalRow.compact({
    super.key,
    required this.interval,
    required this.onChanged,
    required this.onDelete,
  }) : decorated = false;

  final ScheduleInterval interval;
  final ValueChanged<ScheduleInterval>? onChanged;
  final VoidCallback? onDelete;
  final bool decorated;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final start = TimeFormat.formatMinutes(interval.startMin);
    final end = TimeFormat.formatMinutes(interval.endMin);

    final content = Row(
      children: [
        OutlinedButton(
          onPressed: onChanged == null
              ? null
              : () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeFormat.timeOfDayFromMinutes(interval.startMin),
                  );
                  if (picked == null) return;
                  onChanged!(
                    ScheduleInterval(
                      startMin: picked.hour * 60 + picked.minute,
                      endMin: interval.endMin,
                    ),
                  );
                },
          child: Text(l10n.intervalStart(start)),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: onChanged == null
              ? null
              : () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeFormat.timeOfDayFromMinutes(interval.endMin),
                  );
                  if (picked == null) return;
                  onChanged!(
                    ScheduleInterval(
                      startMin: interval.startMin,
                      endMin: picked.hour * 60 + picked.minute,
                    ),
                  );
                },
          child: Text(l10n.intervalEnd(end)),
        ),
        const SizedBox(width: 12),
        const Spacer(),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          tooltip: l10n.intervalRemoveTooltip,
        ),
      ],
    );

    if (!decorated) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: content,
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outlineVariant),
        color: cs.surface.withValues(alpha: 0.5),
      ),
      child: content,
    );
  }
}

