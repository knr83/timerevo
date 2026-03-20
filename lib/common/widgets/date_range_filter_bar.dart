import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../utils/date_time_picker.dart';
import '../utils/date_utils.dart';

/// Scope for date range filter (day, week, month, or custom interval).
enum DateRangeScope { day, week, month, interval }

/// Reusable date range filter bar: scope selector, Today button, and
/// navigator pill with chevrons. Use in Journal, Absences, Reports, etc.
class DateRangeFilterBar extends StatelessWidget {
  const DateRangeFilterBar({
    super.key,
    required this.scope,
    required this.fromUtcMs,
    required this.toUtcMs,
    required this.availableScopes,
    required this.onChanged,
  });

  final DateRangeScope scope;
  final int fromUtcMs;
  final int toUtcMs;
  final List<DateRangeScope> availableScopes;
  final void Function(DateRangeScope scope, int fromUtcMs, int toUtcMs)
  onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final fromLocal = DateTime.fromMillisecondsSinceEpoch(
      fromUtcMs,
      isUtc: true,
    ).toLocal();
    final toLocal = DateTime.fromMillisecondsSinceEpoch(
      toUtcMs,
      isUtc: true,
    ).toLocal();
    final baseDate = DateTime(fromLocal.year, fromLocal.month, fromLocal.day);

    final dateFormat = DateFormat('MMM d', locale);
    String rangeLabel;
    if (scope == DateRangeScope.day) {
      rangeLabel = dateFormat.format(baseDate);
    } else {
      final endDate = DateTime(toLocal.year, toLocal.month, toLocal.day);
      rangeLabel =
          '${dateFormat.format(baseDate)} – ${dateFormat.format(endDate)}';
    }

    void handleToday() {
      final r = switch (scope) {
        DateRangeScope.day => reportPeriodToday(),
        DateRangeScope.week => reportPeriodWeek(),
        DateRangeScope.month => reportPeriodMonth(),
        DateRangeScope.interval => reportPeriodMonth(),
      };
      onChanged(scope, r.fromUtcMs, r.toUtcMs);
    }

    void handlePrev() {
      if (scope == DateRangeScope.interval) return;
      final r = switch (scope) {
        DateRangeScope.day => reportPeriodDay(
          baseDate.subtract(const Duration(days: 1)),
        ),
        DateRangeScope.week => reportPeriodWeekContaining(
          baseDate.subtract(const Duration(days: 7)),
        ),
        DateRangeScope.month => reportPeriodMonthContaining(
          DateTime(baseDate.year, baseDate.month - 1, 1),
        ),
        DateRangeScope.interval => throw StateError('unreachable'),
      };
      onChanged(scope, r.fromUtcMs, r.toUtcMs);
    }

    void handleNext() {
      if (scope == DateRangeScope.interval) return;
      final r = switch (scope) {
        DateRangeScope.day => reportPeriodDay(
          baseDate.add(const Duration(days: 1)),
        ),
        DateRangeScope.week => reportPeriodWeekContaining(
          baseDate.add(const Duration(days: 7)),
        ),
        DateRangeScope.month => reportPeriodMonthContaining(
          DateTime(baseDate.year, baseDate.month + 1, 1),
        ),
        DateRangeScope.interval => throw StateError('unreachable'),
      };
      onChanged(scope, r.fromUtcMs, r.toUtcMs);
    }

    void handleScopeChanged(DateRangeScope newScope) {
      if (newScope == scope) return;
      final r = switch ((scope, newScope)) {
        (_, DateRangeScope.day) => reportPeriodDay(baseDate),
        (_, DateRangeScope.week) => reportPeriodWeekContaining(baseDate),
        (_, DateRangeScope.month) => reportPeriodMonthContaining(baseDate),
        (_, DateRangeScope.interval) => (
          fromUtcMs: fromUtcMs,
          toUtcMs: toUtcMs,
        ),
      };
      onChanged(newScope, r.fromUtcMs, r.toUtcMs);
    }

    Future<void> handlePickRange() async {
      final from = DateTime(fromLocal.year, fromLocal.month, fromLocal.day);
      final to = DateTime(toLocal.year, toLocal.month, toLocal.day);
      final picked = await pickDateRange(
        context,
        initialStartDate: from,
        initialEndDate: to,
      );
      if (picked == null || !context.mounted) return;
      onChanged(DateRangeScope.interval, picked.fromUtcMs, picked.toUtcMs);
    }

    String scopeLabel(DateRangeScope s) {
      return switch (s) {
        DateRangeScope.day => l10n.journalScopeDay,
        DateRangeScope.week => l10n.journalScopeWeek,
        DateRangeScope.month => l10n.journalScopeMonth,
        DateRangeScope.interval => l10n.journalScopeInterval,
      };
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SegmentedButton<DateRangeScope>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          segments: availableScopes
              .map((s) => ButtonSegment(value: s, label: Text(scopeLabel(s))))
              .toList(),
          selected: {scope},
          onSelectionChanged: (s) {
            if (!s.contains(scope)) handleScopeChanged(s.first);
          },
        ),
        TextButton(
          onPressed: handleToday,
          child: Text(l10n.journalPresetToday),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (scope != DateRangeScope.interval)
                IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Symbols.chevron_left),
                  onPressed: handlePrev,
                ),
              InkWell(
                onTap: scope == DateRangeScope.interval
                    ? handlePickRange
                    : null,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Text(rangeLabel, style: theme.textTheme.labelLarge),
                ),
              ),
              if (scope != DateRangeScope.interval)
                IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Symbols.chevron_right),
                  onPressed: handleNext,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
