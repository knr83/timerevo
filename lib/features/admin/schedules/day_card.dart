import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/schedule_entities.dart';
import '../../../common/widgets/schedule_interval_display_row.dart';
import 'interval_edit_dialog.dart';

String _weekdayLabel(int weekday, AppLocalizations l10n) {
  return switch (weekday) {
    1 => l10n.weekdayMonday,
    2 => l10n.weekdayTuesday,
    3 => l10n.weekdayWednesday,
    4 => l10n.weekdayThursday,
    5 => l10n.weekdayFriday,
    6 => l10n.weekdaySaturday,
    _ => l10n.weekdaySunday,
  };
}

int _totalMinutesForDay(DaySchedule day) {
  var total = 0;
  for (final i in day.intervals) {
    total += i.endMin - i.startMin;
  }
  return total;
}

String _formatTotalHours(AppLocalizations l10n, int totalMin) {
  if (totalMin <= 0) return l10n.schedulesTotalHours('0');
  final hours = totalMin / 60;
  final s = hours == hours.roundToDouble()
      ? hours.toInt().toString()
      : hours.toStringAsFixed(1);
  return l10n.schedulesTotalHours(s);
}

/// Day card for the week editor grid.
class WeekEditorDayCard extends ConsumerWidget {
  const WeekEditorDayCard({
    super.key,
    required this.weekday,
    required this.day,
    required this.onUpdateDay,
  });

  final int weekday;
  final DaySchedule day;
  final ValueChanged<DaySchedule> onUpdateDay;

  Future<void> _addInterval(BuildContext context) async {
    final result = await showIntervalEditDialog(
      context: context,
      isAdd: true,
      existingIntervals: day.intervals,
    );
    if (result == null || !context.mounted) return;
    final intervals = [
      ...day.intervals,
      ScheduleInterval(startMin: result.startMin, endMin: result.endMin),
    ];
    onUpdateDay(DaySchedule(isDayOff: false, intervals: intervals));
  }

  Future<void> _editInterval(BuildContext context, int index) async {
    final result = await showIntervalEditDialog(
      context: context,
      isAdd: false,
      existingIntervals: day.intervals,
      initial: day.intervals[index],
    );
    if (result == null || !context.mounted) return;
    final intervals = [...day.intervals];
    intervals[index] = ScheduleInterval(
      startMin: result.startMin,
      endMin: result.endMin,
    );
    onUpdateDay(DaySchedule(isDayOff: false, intervals: intervals));
  }

  void _deleteInterval(int index) {
    final intervals = [...day.intervals];
    intervals.removeAt(index);
    onUpdateDay(DaySchedule(isDayOff: intervals.isEmpty, intervals: intervals));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final label = _weekdayLabel(weekday, l10n);
    final totalMin = _totalMinutesForDay(day);
    final hasIntervals = day.intervals.isNotEmpty;

    const minCardHeight = 180.0; // Fits ~2 interval rows + header + add link.

    return Card(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: minCardHeight),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(label, style: Theme.of(context).textTheme.titleMedium),
                  if (hasIntervals && totalMin > 0) ...[
                    const Spacer(),
                    Text(
                      _formatTotalHours(l10n, totalMin),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              if (hasIntervals)
                ...day.intervals.asMap().entries.map((e) {
                  final idx = e.key;
                  final interval = e.value;
                  return ScheduleIntervalDisplayRow(
                    interval: interval,
                    onTap: () => _editInterval(context, idx),
                    onDelete: () => _deleteInterval(idx),
                  );
                }),
              const SizedBox(height: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton.icon(
                  onPressed: () => _addInterval(context),
                  icon: const Icon(Symbols.add, size: 18),
                  label: Text(l10n.schedulesAddInterval),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
