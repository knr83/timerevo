import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/sessions_providers.dart';
import '../../../common/utils/employee_display_name.dart';
import '../../../common/utils/time_format.dart';
import '../../../core/error_message_helper.dart';
import '../../../domain/entities/employee_display.dart';
import '../../../domain/entities/employee_info.dart';
import '../../../domain/entities/session_info.dart';
import '../../../domain/entities/session_with_employee_info.dart';

int _minutesBetweenUtcMs(int startUtcMs, int endUtcMs) {
  final startMin = (startUtcMs / 60000).floor();
  final endMin = (endUtcMs / 60000).floor();
  return (endMin - startMin).clamp(0, 999999);
}

String _formatDuration(AppLocalizations l10n, int totalMin) {
  if (totalMin <= 0) return l10n.terminalDurationLessThanOneMin;
  final h = totalMin ~/ 60;
  final m = totalMin % 60;
  if (h == 0) return l10n.terminalDurationMinutesOnly(m);
  if (m == 0) return l10n.terminalDurationHoursOnly(h);
  return l10n.durationHm(h, m);
}

class _DashboardSessionRow extends StatelessWidget {
  const _DashboardSessionRow({
    required this.session,
    required this.openSessionId,
    required this.l10n,
  });

  final SessionInfo session;
  final int? openSessionId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final isOpen = session.id == openSessionId;
    final start = TimeFormat.formatTimeOnly(session.startTs);
    final String trailing;
    if (isOpen) {
      trailing = _formatDuration(
        l10n,
        _minutesBetweenUtcMs(session.startTs, nowMs),
      );
    } else if (session.endTs != null) {
      trailing = _formatDuration(
        l10n,
        _minutesBetweenUtcMs(session.startTs, session.endTs!),
      );
    } else {
      trailing = l10n.commonOngoing;
    }
    final endStr = session.endTs != null
        ? TimeFormat.formatTimeOnly(session.endTs!)
        : '…';
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Material(
      color: isOpen ? cs.primaryContainer.withValues(alpha: 0.5) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              isOpen ? Icons.schedule : Icons.check_circle_outline,
              size: 20,
              color: isOpen ? cs.primary : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 95,
              child: Text(
                '$start – $endStr',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            Expanded(
              child: Text(
                trailing,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isOpen ? cs.primary : cs.onSurfaceVariant,
                  fontWeight: isOpen ? FontWeight.w600 : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeSessionsBlock extends ConsumerWidget {
  const _EmployeeSessionsBlock({
    required this.employeeId,
    required this.openSessionId,
    required this.l10n,
    this.useRecentRange = false,
  });

  final int employeeId;
  final int? openSessionId;
  final AppLocalizations l10n;

  /// When true, fetches sessions for last 7 days (for Recent Activity context).
  final bool useRecentRange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = useRecentRange
        ? ref.watch(watchSessionsForEmployeeLastDaysProvider((employeeId, 7)))
        : ref.watch(watchSessionsForEmployeeTodayProvider(employeeId));

    return sessionsAsync.when(
      data: (sessions) {
        if (sessions.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(left: 32, top: 4, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final s in sessions) ...[
                _DashboardSessionRow(
                  session: s,
                  openSessionId: openSessionId,
                  l10n: l10n,
                ),
                if (s != sessions.last) const Divider(height: 1),
              ],
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.only(left: 32, top: 4, bottom: 8),
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key, this.onViewAllSessions});

  final VoidCallback? onViewAllSessions;

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int? _expandedInNowAtWork;
  int? _expandedInTodayEmployees;
  int? _expandedSessionIdInRecentActivity;

  void _toggleExpandInNowAtWork(int employeeId) {
    setState(() {
      _expandedInNowAtWork = _expandedInNowAtWork == employeeId
          ? null
          : employeeId;
    });
  }

  void _toggleExpandInTodayEmployees(int employeeId) {
    setState(() {
      _expandedInTodayEmployees = _expandedInTodayEmployees == employeeId
          ? null
          : employeeId;
    });
  }

  void _toggleExpandInRecentActivity(int sessionId) {
    setState(() {
      _expandedSessionIdInRecentActivity =
          _expandedSessionIdInRecentActivity == sessionId ? null : sessionId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashboardTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final useRow = constraints.maxWidth >= 600;
              return useRow
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _DashboardNowAtWork(
                            expandedEmployeeId: _expandedInNowAtWork,
                            onExpandSessions: _toggleExpandInNowAtWork,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _DashboardTodayEmployees(
                            expandedEmployeeId: _expandedInTodayEmployees,
                            onExpandSessions: _toggleExpandInTodayEmployees,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _DashboardNowAtWork(
                          expandedEmployeeId: _expandedInNowAtWork,
                          onExpandSessions: _toggleExpandInNowAtWork,
                        ),
                        const SizedBox(height: 16),
                        _DashboardTodayEmployees(
                          expandedEmployeeId: _expandedInTodayEmployees,
                          onExpandSessions: _toggleExpandInTodayEmployees,
                        ),
                      ],
                    );
            },
          ),
          const SizedBox(height: 16),
          _DashboardRecentActivity(
            onViewAllSessions: widget.onViewAllSessions,
            expandedSessionId: _expandedSessionIdInRecentActivity,
            onExpandSession: _toggleExpandInRecentActivity,
          ),
        ],
      ),
    );
  }
}

class _DashboardNowAtWork extends ConsumerStatefulWidget {
  const _DashboardNowAtWork({
    this.expandedEmployeeId,
    required this.onExpandSessions,
  });

  final int? expandedEmployeeId;
  final void Function(int employeeId) onExpandSessions;

  @override
  ConsumerState<_DashboardNowAtWork> createState() =>
      _DashboardNowAtWorkState();
}

class _DashboardNowAtWorkState extends ConsumerState<_DashboardNowAtWork> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final openAsync = ref.watch(watchOpenSessionsProvider);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardNowAtWork,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            openAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.dashboardNoOneAtWork,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final sw in sessions) ...[
                      _NowAtWorkRow(
                        session: sw.session,
                        employee: sw.employee,
                        l10n: l10n,
                        expandedEmployeeId: widget.expandedEmployeeId,
                        onExpandSessions: widget.onExpandSessions,
                      ),
                      if (widget.expandedEmployeeId == sw.employee.id)
                        _EmployeeSessionsBlock(
                          employeeId: sw.employee.id,
                          openSessionId: sw.session.id,
                          l10n: l10n,
                        ),
                      if (sw != sessions.last) const Divider(height: 1),
                    ],
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Text(
                l10n.terminalFailedLoadEmployees(
                  errorMessageForUser(e, l10n.commonErrorOccurred),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Clickable employee name with clear visual affordance.
class _EmployeeNameTap extends StatelessWidget {
  const _EmployeeNameTap({
    required this.name,
    this.onTap,
    this.isExpanded = false,
  });

  final String name;
  final VoidCallback? onTap;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (onTap == null) {
      return Text(name, style: theme.textTheme.bodyMedium);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 18,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NowAtWorkRow extends StatelessWidget {
  const _NowAtWorkRow({
    required this.session,
    required this.employee,
    required this.l10n,
    required this.expandedEmployeeId,
    required this.onExpandSessions,
  });

  final SessionInfo session;
  final EmployeeInfo employee;
  final AppLocalizations l10n;
  final int? expandedEmployeeId;
  final void Function(int employeeId) onExpandSessions;

  @override
  Widget build(BuildContext context) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final totalMin = _minutesBetweenUtcMs(session.startTs, nowMs);
    final durationStr = _formatDuration(l10n, totalMin);
    final isExpanded = expandedEmployeeId == employee.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          _EmployeeNameTap(
            name: EmployeeDisplayName.of(
              EmployeeDisplay(
                firstName: employee.firstName,
                lastName: employee.lastName,
              ),
            ),
            onTap: () => onExpandSessions(employee.id),
            isExpanded: isExpanded,
          ),
          const Spacer(),
          Text(
            durationStr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayEmployeeRow {
  const _TodayEmployeeRow({
    required this.employee,
    required this.totalMin,
    required this.isAtWork,
    this.openSessionId,
  });

  final EmployeeInfo employee;
  final int totalMin;
  final bool isAtWork;
  final int? openSessionId;
}

List<_TodayEmployeeRow> _aggregateTodayEmployees(
  List<SessionWithEmployeeInfo> todaySessions,
  List<SessionWithEmployeeInfo> openSessions,
) {
  final nowMs = DateTime.now().millisecondsSinceEpoch;
  final openByEmployee = <int, int>{};
  for (final sw in openSessions) {
    openByEmployee[sw.employee.id] = sw.session.id;
  }
  final map =
      <
        int,
        ({
          EmployeeInfo employee,
          int totalMs,
          bool isAtWork,
          int? openSessionId,
        })
      >{};

  for (final sw in todaySessions) {
    final e = sw.employee;
    final s = sw.session;
    final entry = map.putIfAbsent(
      e.id,
      () => (employee: e, totalMs: 0, isAtWork: false, openSessionId: null),
    );
    final durationMs = s.endTs != null
        ? s.endTs! - s.startTs
        : nowMs - s.startTs;
    final openSessionId = openByEmployee[e.id];
    map[e.id] = (
      employee: e,
      totalMs: entry.totalMs + durationMs,
      isAtWork: entry.isAtWork || openSessionId != null,
      openSessionId: openSessionId ?? entry.openSessionId,
    );
  }

  return map.values
      .map(
        (e) => _TodayEmployeeRow(
          employee: e.employee,
          totalMin: (e.totalMs / 60000).floor(),
          isAtWork: e.isAtWork,
          openSessionId: e.openSessionId,
        ),
      )
      .toList()
    ..sort((a, b) {
      if (a.isAtWork != b.isAtWork) return a.isAtWork ? -1 : 1;
      return b.employee.id.compareTo(a.employee.id);
    });
}

class _DashboardTodayEmployees extends ConsumerStatefulWidget {
  const _DashboardTodayEmployees({
    this.expandedEmployeeId,
    required this.onExpandSessions,
  });

  final int? expandedEmployeeId;
  final void Function(int employeeId) onExpandSessions;

  @override
  ConsumerState<_DashboardTodayEmployees> createState() =>
      _DashboardTodayEmployeesState();
}

class _DashboardTodayEmployeesState
    extends ConsumerState<_DashboardTodayEmployees> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final todayAsync = ref.watch(watchTodaySessionsProvider);
    final openAsync = ref.watch(watchOpenSessionsProvider);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardToday,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            todayAsync.when(
              data: (todaySessions) {
                final openSessions = openAsync.valueOrNull ?? [];
                final rows = _aggregateTodayEmployees(
                  todaySessions,
                  openSessions,
                );
                if (rows.isEmpty) {
                  return Text(
                    l10n.dashboardNoEmployeesToday,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final row in rows) ...[
                      _TodayEmployeeListRow(
                        row: row,
                        l10n: l10n,
                        expandedEmployeeId: widget.expandedEmployeeId,
                        onExpandSessions: widget.onExpandSessions,
                      ),
                      if (widget.expandedEmployeeId == row.employee.id)
                        _EmployeeSessionsBlock(
                          employeeId: row.employee.id,
                          openSessionId: row.openSessionId,
                          l10n: l10n,
                        ),
                      if (row != rows.last) const Divider(height: 1),
                    ],
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Text(
                l10n.terminalFailedLoadEmployees(
                  errorMessageForUser(e, l10n.commonErrorOccurred),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayEmployeeListRow extends StatelessWidget {
  const _TodayEmployeeListRow({
    required this.row,
    required this.l10n,
    required this.expandedEmployeeId,
    required this.onExpandSessions,
  });

  final _TodayEmployeeRow row;
  final AppLocalizations l10n;
  final int? expandedEmployeeId;
  final void Function(int employeeId) onExpandSessions;

  @override
  Widget build(BuildContext context) {
    final durationStr = _formatDuration(l10n, row.totalMin);
    final isExpanded = expandedEmployeeId == row.employee.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            row.isAtWork ? Icons.schedule : Icons.check_circle_outline,
            size: 20,
            color: row.isAtWork
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          _EmployeeNameTap(
            name: EmployeeDisplayName.of(
              EmployeeDisplay(
                firstName: row.employee.firstName,
                lastName: row.employee.lastName,
              ),
            ),
            onTap: () => onExpandSessions(row.employee.id),
            isExpanded: isExpanded,
          ),
          const Spacer(),
          Text(
            durationStr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardRecentActivity extends ConsumerWidget {
  const _DashboardRecentActivity({
    this.onViewAllSessions,
    required this.expandedSessionId,
    required this.onExpandSession,
  });

  final VoidCallback? onViewAllSessions;
  final int? expandedSessionId;
  final void Function(int sessionId) onExpandSession;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recentAsync = ref.watch(watchRecentSessionsProvider);
    final openAsync = ref.watch(watchOpenSessionsProvider);
    final openByEmployee = <int, int>{};
    for (final sw in openAsync.valueOrNull ?? []) {
      openByEmployee[sw.employee.id] = sw.session.id;
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.dashboardRecentActivity,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onViewAllSessions != null)
                  FilledButton.tonal(
                    onPressed: onViewAllSessions,
                    child: Text(l10n.dashboardViewAllSessions),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            recentAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) {
                  return Text(
                    l10n.dashboardNoRecentActivity,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final sw in sessions) ...[
                      _RecentActivityRow(
                        session: sw.session,
                        employee: sw.employee,
                        expandedSessionId: expandedSessionId,
                        onExpandSession: onExpandSession,
                      ),
                      if (expandedSessionId == sw.session.id)
                        _EmployeeSessionsBlock(
                          employeeId: sw.employee.id,
                          openSessionId: openByEmployee[sw.employee.id],
                          l10n: l10n,
                          useRecentRange: true,
                        ),
                      if (sw != sessions.last) const Divider(height: 1),
                    ],
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Text(
                l10n.terminalFailedLoadEmployees(
                  errorMessageForUser(e, l10n.commonErrorOccurred),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivityRow extends StatelessWidget {
  const _RecentActivityRow({
    required this.session,
    required this.employee,
    required this.expandedSessionId,
    required this.onExpandSession,
  });

  final SessionInfo session;
  final EmployeeInfo employee;
  final int? expandedSessionId;
  final void Function(int sessionId) onExpandSession;

  @override
  Widget build(BuildContext context) {
    final isOpen = session.endTs == null;
    final eventTime = isOpen ? session.startTs : session.endTs!;
    final timeStr = TimeFormat.formatTimeOnly(eventTime);
    final isExpanded = expandedSessionId == session.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isOpen ? Icons.login_rounded : Icons.logout_rounded,
            size: 20,
            color: isOpen
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          _EmployeeNameTap(
            name: EmployeeDisplayName.of(
              EmployeeDisplay(
                firstName: employee.firstName,
                lastName: employee.lastName,
              ),
            ),
            onTap: () => onExpandSession(session.id),
            isExpanded: isExpanded,
          ),
          const Spacer(),
          Text(
            timeStr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
