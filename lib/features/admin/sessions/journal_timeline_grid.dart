import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../../common/utils/employee_display_name.dart';
import '../../../common/utils/time_format.dart';
import '../../../core/journal_interval_projection.dart';
import '../../../domain/entities/employee_display.dart';
import '../../../domain/entities/journal_day_overview_row.dart';
import '../../../domain/entities/journal_day_state.dart';

/// Color for a timeline cell state. Reused by cells and legend.
Color _colorForState(JournalDayState state, ColorScheme cs) {
  return switch (state) {
    JournalDayState.ongoing => cs.primary,
    JournalDayState.present => cs.primary.withValues(alpha: 0.5),
    JournalDayState.approvedAbsence => cs.tertiary.withValues(alpha: 0.5),
    JournalDayState.expectedNoShow => cs.error.withValues(alpha: 0.4),
    JournalDayState.noData => cs.surfaceContainerHighest,
  };
}

/// Compact legend row for timeline cell states.
class _TimelineLegend extends StatelessWidget {
  const _TimelineLegend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final cs = theme.colorScheme;
    const spacing = 12.0;

    final entries = [
      (JournalDayState.ongoing, l10n.journalTimelineStateOngoing),
      (JournalDayState.present, l10n.journalTimelineStatePresent),
      (
        JournalDayState.approvedAbsence,
        l10n.journalTimelineStateApprovedAbsence,
      ),
      (JournalDayState.expectedNoShow, l10n.journalTimelineStateExpectedNoShow),
      (JournalDayState.noData, l10n.journalTimelineStateNoData),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: spacing,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final (state, label) in entries)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _colorForState(state, cs),
                    borderRadius: BorderRadius.circular(4),
                    border: state == JournalDayState.noData
                        ? Border.all(
                            color: cs.outline.withValues(alpha: 0.5),
                            width: 1,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Read-only grid: rows = employees, columns = days. Each cell shows one state.
class JournalTimelineGrid extends StatelessWidget {
  const JournalTimelineGrid({
    super.key,
    required this.rows,
    required this.fromUtcMs,
    required this.toUtcMs,
  });

  final List<JournalDayOverviewRow> rows;
  final int fromUtcMs;
  final int toUtcMs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    final fromLocal = DateTime.fromMillisecondsSinceEpoch(
      fromUtcMs,
      isUtc: true,
    ).toLocal();
    final toLocal = DateTime.fromMillisecondsSinceEpoch(
      toUtcMs,
      isUtc: true,
    ).toLocal();
    final fromDate = DateTime(fromLocal.year, fromLocal.month, fromLocal.day);
    final toDate = DateTime(toLocal.year, toLocal.month, toLocal.day);

    final dayCount = toDate.difference(fromDate).inDays + 1;
    if (dayCount <= 0) {
      return Center(child: Text(l10n.journalTimelinePickRangeHint));
    }

    const cellWidth = 28.0;
    const nameColumnWidth = 160.0;

    final dayHeaders = <Widget>[];
    final dayDates = <DateTime>[];
    var d = fromDate;
    while (!d.isAfter(toDate)) {
      if (d.weekday == DateTime.monday && d != fromDate) {
        dayHeaders.add(
          Container(
            width: 1,
            height: 32,
            color: theme.dividerColor.withValues(alpha: 0.5),
          ),
        );
      }
      dayHeaders.add(
        Container(
          width: cellWidth,
          height: 32,
          decoration: BoxDecoration(
            color:
                d.weekday == DateTime.saturday || d.weekday == DateTime.sunday
                ? theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5)
                : null,
          ),
          child: Center(
            child: Text(
              DateFormat.d(locale).format(d),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
      dayDates.add(d);
      d = d.add(const Duration(days: 1));
    }

    final dataRows = rows.map((row) {
      final name = EmployeeDisplayName.of(
        EmployeeDisplay(firstName: row.firstName, lastName: row.lastName),
      );
      final cells = <Widget>[];
      for (var i = 0; i < dayCount && i < row.cells.length; i++) {
        if (i > 0 && dayDates[i].weekday == DateTime.monday) {
          cells.add(
            Container(
              width: 1,
              height: 32,
              color: theme.dividerColor.withValues(alpha: 0.5),
            ),
          );
        }
        final isWeekend =
            dayDates[i].weekday == DateTime.saturday ||
            dayDates[i].weekday == DateTime.sunday;
        cells.add(
          _DayCell(
            state: row.cells[i],
            tooltip: _stateTooltip(row.cells[i], l10n),
            isWeekend: isWeekend,
          ),
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: nameColumnWidth,
            height: 32,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          ...cells,
        ],
      );
    }).toList();

    final headerRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: nameColumnWidth,
          height: 32,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.sessionsTableEmployee,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        ...dayHeaders,
      ],
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
          ),
          child: headerRow,
        ),
        ...dataRows,
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TimelineLegend(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: content,
            ),
          ),
        ),
      ],
    );
  }

  String _stateTooltip(JournalDayState state, AppLocalizations l10n) {
    return switch (state) {
      JournalDayState.ongoing => l10n.journalTimelineStateOngoing,
      JournalDayState.present => l10n.journalTimelineStatePresent,
      JournalDayState.approvedAbsence =>
        l10n.journalTimelineStateApprovedAbsence,
      JournalDayState.expectedNoShow => l10n.journalTimelineStateExpectedNoShow,
      JournalDayState.noData => l10n.journalTimelineStateNoData,
    };
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.state,
    required this.tooltip,
    this.isWeekend = false,
  });

  final JournalDayState state;
  final String tooltip;
  final bool isWeekend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const size = 28.0;
    final color = _colorForState(state, cs);

    final inner = Center(
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: state == JournalDayState.noData
              ? Border.all(color: cs.outline.withValues(alpha: 0.5), width: 1)
              : null,
        ),
      ),
    );

    final cell = Container(
      width: size,
      height: 32,
      decoration: isWeekend
          ? BoxDecoration(color: cs.surfaceContainerLow.withValues(alpha: 0.2))
          : null,
      child: inner,
    );

    return Tooltip(message: tooltip, child: cell);
  }
}

/// Color for an interval kind in the detailed timeline.
Color _colorForIntervalKind(JournalIntervalKind kind, ColorScheme cs) {
  return switch (kind) {
    JournalIntervalKind.work => cs.primary.withValues(alpha: 0.5),
    JournalIntervalKind.absence => cs.tertiary.withValues(alpha: 0.5),
    JournalIntervalKind.ongoing => cs.primary,
  };
}

/// Legend for detailed timeline interval kinds.
class _DetailedTimelineLegend extends StatelessWidget {
  const _DetailedTimelineLegend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final cs = theme.colorScheme;
    const spacing = 12.0;

    final entries = [
      (JournalIntervalKind.work, l10n.journalIntervalLegendWork),
      (JournalIntervalKind.absence, l10n.journalIntervalLegendApprovedAbsence),
      (JournalIntervalKind.ongoing, l10n.journalIntervalLegendOngoing),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: spacing,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final (kind, label) in entries)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _colorForIntervalKind(kind, cs),
                    borderRadius: BorderRadius.circular(4),
                    border: kind == JournalIntervalKind.ongoing
                        ? Border.all(color: cs.primary, width: 3)
                        : null,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

const _dayColumnWidth = 140.0;
const _nameColumnWidth = 160.0;
const _rowHeight = 40.0;
const _barHeight = 32.0;
const _minBarWidth = 21.0;
const _dayTimelineHorizontalPadding = 12.0;

/// Detailed timeline grid: intervals per day, proportionally positioned.
class JournalDetailedTimelineGrid extends StatelessWidget {
  const JournalDetailedTimelineGrid({
    super.key,
    required this.rows,
    required this.fromUtcMs,
    required this.toUtcMs,
    required this.startMin,
    required this.endMin,
  });

  final List<JournalIntervalRow> rows;
  final int fromUtcMs;
  final int toUtcMs;
  final int startMin;
  final int endMin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();

    final fromLocal = DateTime.fromMillisecondsSinceEpoch(
      fromUtcMs,
      isUtc: true,
    ).toLocal();
    final toLocal = DateTime.fromMillisecondsSinceEpoch(
      toUtcMs,
      isUtc: true,
    ).toLocal();
    final fromDate = DateTime(fromLocal.year, fromLocal.month, fromLocal.day);
    final toDate = DateTime(toLocal.year, toLocal.month, toLocal.day);

    final dayCount = toDate.difference(fromDate).inDays + 1;
    if (dayCount <= 0) {
      return Center(child: Text(l10n.journalTimelinePickRangeHint));
    }

    final windowDurationMin = endMin - startMin;
    final dayDates = <DateTime>[];
    var d = fromDate;
    while (!d.isAfter(toDate)) {
      dayDates.add(d);
      d = d.add(const Duration(days: 1));
    }

    if (dayCount == 1) {
      return _buildDayModeLayout(
        context,
        theme: theme,
        l10n: l10n,
        dayDates: dayDates,
        rows: rows,
        startMin: startMin,
        endMin: endMin,
        windowDurationMin: windowDurationMin,
      );
    }

    final dayHeaders = <Widget>[];
    for (var i = 0; i < dayDates.length; i++) {
      if (i > 0 && dayDates[i].weekday == DateTime.monday) {
        dayHeaders.add(
          Container(
            width: 1,
            height: 32,
            color: theme.dividerColor.withValues(alpha: 0.5),
          ),
        );
      }
      final day = dayDates[i];
      dayHeaders.add(
        Container(
          width: _dayColumnWidth,
          height: 32,
          decoration: BoxDecoration(
            color:
                day.weekday == DateTime.saturday ||
                    day.weekday == DateTime.sunday
                ? theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5)
                : null,
          ),
          child: Center(
            child: Text(
              DateFormat.d(locale).format(day),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    final dataRows = rows.map((row) {
      final name = EmployeeDisplayName.of(
        EmployeeDisplay(firstName: row.firstName, lastName: row.lastName),
      );
      final cells = <Widget>[];
      for (var i = 0; i < dayCount && i < row.cells.length; i++) {
        if (i > 0 && dayDates[i].weekday == DateTime.monday) {
          cells.add(
            Container(
              width: 1,
              height: _rowHeight,
              color: theme.dividerColor.withValues(alpha: 0.5),
            ),
          );
        }
        final isWeekend =
            dayDates[i].weekday == DateTime.saturday ||
            dayDates[i].weekday == DateTime.sunday;
        cells.add(
          _DetailedDayCell(
            intervals: row.cells[i],
            dayDate: dayDates[i],
            startMin: startMin,
            endMin: endMin,
            windowDurationMin: windowDurationMin,
            dayColumnWidth: _dayColumnWidth,
            isWeekend: isWeekend,
            l10n: l10n,
          ),
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _nameColumnWidth,
            height: _rowHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          ...cells,
        ],
      );
    }).toList();

    final headerRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _nameColumnWidth,
          height: 32,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.sessionsTableEmployee,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        ...dayHeaders,
      ],
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
          ),
          child: headerRow,
        ),
        ...dataRows,
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _DetailedTimelineLegend(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: content,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayModeLayout(
    BuildContext context, {
    required ThemeData theme,
    required AppLocalizations l10n,
    required List<DateTime> dayDates,
    required List<JournalIntervalRow> rows,
    required int startMin,
    required int endMin,
    required int windowDurationMin,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _DetailedTimelineLegend(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final timelineWidth =
                  (constraints.maxWidth - _nameColumnWidth - 1).clamp(
                    200.0,
                    double.infinity,
                  );
              final dayDate = dayDates.first;
              final isWeekend =
                  dayDate.weekday == DateTime.saturday ||
                  dayDate.weekday == DateTime.sunday;

              const headerHeight = 32.0;
              final headerRow = Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: _nameColumnWidth,
                    height: headerHeight,
                    child: ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            l10n.sessionsTableEmployee,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  SizedBox(
                    width: timelineWidth,
                    height: headerHeight,
                    child: _DayTimelineHeader(
                      startMin: startMin,
                      endMin: endMin,
                      windowDurationMin: windowDurationMin,
                      width: timelineWidth,
                      horizontalPadding: _dayTimelineHorizontalPadding,
                      theme: theme,
                    ),
                  ),
                ],
              );

              final dataRows = rows.map((row) {
                final name = EmployeeDisplayName.of(
                  EmployeeDisplay(
                    firstName: row.firstName,
                    lastName: row.lastName,
                  ),
                );
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: _nameColumnWidth,
                      height: _rowHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            name,
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    SizedBox(
                      width: timelineWidth,
                      height: _rowHeight,
                      child: _DetailedDayCell(
                        intervals: row.cells.isNotEmpty ? row.cells.first : [],
                        dayDate: dayDate,
                        startMin: startMin,
                        endMin: endMin,
                        windowDurationMin: windowDurationMin,
                        dayColumnWidth: timelineWidth,
                        horizontalPadding: _dayTimelineHorizontalPadding,
                        isWeekend: isWeekend,
                        l10n: l10n,
                      ),
                    ),
                  ],
                );
              }).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                      ),
                      child: headerRow,
                    ),
                    ...dataRows,
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayTimelineHeader extends StatelessWidget {
  const _DayTimelineHeader({
    required this.startMin,
    required this.endMin,
    required this.windowDurationMin,
    required this.width,
    required this.horizontalPadding,
    required this.theme,
  });

  final int startMin;
  final int endMin;
  final int windowDurationMin;
  final double width;
  final double horizontalPadding;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final hourLabels = <Widget>[];
    final usableWidth = width - 2 * horizontalPadding;
    var min = (startMin ~/ 60) * 60;
    final endHour = endMin ~/ 60;
    while (min <= endHour * 60 && min <= endMin) {
      final frac = (min - startMin) / windowDurationMin;
      final tickLeft = horizontalPadding + (frac.clamp(0.0, 1.0) * usableWidth);
      const labelHalfWidth = 18.0;
      final labelLeft = (tickLeft - labelHalfWidth).clamp(
        0.0,
        width - 2 * labelHalfWidth,
      );
      hourLabels.add(
        Positioned(
          left: labelLeft,
          top: 0,
          bottom: 0,
          child: Center(
            child: Text(
              TimeFormat.formatMinutes(min),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
      min += 60;
    }

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Stack(clipBehavior: Clip.none, children: hourLabels),
    );
  }
}

class _DetailedDayCell extends StatelessWidget {
  const _DetailedDayCell({
    required this.intervals,
    required this.dayDate,
    required this.startMin,
    required this.endMin,
    required this.windowDurationMin,
    required this.dayColumnWidth,
    this.horizontalPadding = 4.0,
    required this.isWeekend,
    required this.l10n,
  });

  final List<JournalIntervalItem> intervals;
  final DateTime dayDate;
  final int startMin;
  final int endMin;
  final int windowDurationMin;
  final double dayColumnWidth;
  final double horizontalPadding;
  final bool isWeekend;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dayStartUtc = DateTime(
      dayDate.year,
      dayDate.month,
      dayDate.day,
    ).add(Duration(minutes: startMin)).toUtc().millisecondsSinceEpoch;

    final usableWidth = dayColumnWidth - 2 * horizontalPadding;
    final barWidgets = <Widget>[];
    for (var i = 0; i < intervals.length; i++) {
      final item = intervals[i];
      final startOffsetMin = (item.startUtcMs - dayStartUtc) / 60000;
      final durationMin = (item.endUtcMs - item.startUtcMs) / 60000;
      var leftFrac = startOffsetMin / windowDurationMin;
      var widthFrac = durationMin / windowDurationMin;
      leftFrac = leftFrac.clamp(0.0, 1.0);
      widthFrac = widthFrac.clamp(0.0, 1.0 - leftFrac);

      var barWidth = widthFrac * usableWidth;
      if (barWidth < _minBarWidth) barWidth = _minBarWidth;

      final durationMs = item.endUtcMs - item.startUtcMs;
      final durationMinutes = (durationMs / 60000).round();
      final durationText = durationMinutes >= 60
          ? l10n.durationHm(durationMinutes ~/ 60, durationMinutes % 60)
          : '${durationMinutes}m';
      final durationForTooltip = durationMinutes >= 60
          ? l10n.durationHm(durationMinutes ~/ 60, durationMinutes % 60)
          : l10n.journalIntervalDurationMinutes(durationMinutes);

      final startStr = TimeFormat.formatTimeOnly(item.startUtcMs);
      final endStr = TimeFormat.formatTimeOnly(item.endUtcMs);
      final String tooltip;
      if (item.kind == JournalIntervalKind.ongoing) {
        tooltip = '$startStr–${l10n.journalIntervalNow}, $durationForTooltip';
      } else {
        tooltip = '$startStr–$endStr, $durationForTooltip';
      }

      final color = _colorForIntervalKind(item.kind, cs);
      final showDurationInline = barWidth >= 44;

      final bar = Container(
        width: barWidth,
        height: _barHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: item.kind == JournalIntervalKind.ongoing
              ? Border.all(color: cs.primary, width: 3)
              : null,
        ),
        child: showDurationInline
            ? Center(
                child: Text(
                  durationText,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: item.kind == JournalIntervalKind.absence
                        ? cs.onTertiary
                        : cs.onPrimary,
                  ),
                  overflow: TextOverflow.clip,
                ),
              )
            : null,
      );

      barWidgets.add(
        Positioned(
          left: horizontalPadding + leftFrac * usableWidth,
          top: (_rowHeight - _barHeight) / 2,
          child: Tooltip(message: tooltip, child: bar),
        ),
      );
    }

    final midlineLeft = horizontalPadding + 0.5 * usableWidth;

    return Container(
      width: dayColumnWidth,
      height: _rowHeight,
      decoration: isWeekend
          ? BoxDecoration(color: cs.surfaceContainerLow.withValues(alpha: 0.2))
          : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: midlineLeft,
            top: 0,
            bottom: 0,
            child: Container(
              width: 1,
              color: cs.outline.withValues(alpha: 0.25),
            ),
          ),
          ...barWidgets,
        ],
      ),
    );
  }
}
