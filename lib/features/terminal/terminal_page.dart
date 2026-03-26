import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/auth/admin_auth_controller.dart';
import '../../app/router.dart';
import '../../app/terminal_providers.dart';
import '../../app/usecase_providers.dart';
import '../../app/tracking_start/tracking_start_settings_controller.dart'
    show trackingStartSettingsProvider, trackingStartYmdFromWatch;
import '../../app/attendance/attendance_settings_controller.dart';
import '../../app/working_hours/working_hours_settings_controller.dart';
import '../../core/attendance_mode.dart';
import '../../common/pdf/employee_daily_pdf_export.dart';
import '../../common/utils/date_time_picker.dart';
import '../../common/utils/date_utils.dart';
import '../../common/utils/employee_display_name.dart';
import '../../common/utils/is_past_working_day_end.dart';
import '../../common/utils/terminal_session_duration_format.dart';
import '../../common/utils/time_format.dart';
import '../../common/utils/utc_clock.dart';
import '../../common/widgets/app_snack.dart';
import '../../core/domain_errors.dart';
import '../../core/starting_balance_period.dart';
import '../../core/tracking_start_range_clamp.dart';
import '../../core/diagnostic_log.dart';
import '../../core/employee_pin_status.dart';
import '../../domain/entities/employee_display.dart';
import '../../domain/entities/employee_info.dart';
import '../../domain/entities/session_info.dart';
import '../../domain/usecases.dart';
import '../../ui/legal/legal_links.dart';
import 'employee_calendar_page.dart';
import 'terminal_controller.dart';

void _appendTerminalDiagnosticUnawaited({
  required DiagnosticEvent event,
  String? errorType,
}) {
  unawaited(
    DiagnosticLog.append(
      DiagnosticLogEntry(
        event: event,
        ts: DateTime.now().toUtc().toIso8601String(),
        errorType: errorType,
      ),
    ),
  );
}

Color _clockSuccessBarrierColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
    ? Colors.black26
    : Colors.black54;

class TerminalPage extends ConsumerWidget {
  const TerminalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(terminalControllerProvider);
    final employeesAsync = ref.watch(terminalEmployeesProvider);
    // Prefetch attendance settings so they are ready before user taps IN/OUT.
    ref.watch(attendanceSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.terminalTitle),
        actions: [
          TextButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed(AppRoutes.admin);
              if (context.mounted) {
                ref.read(adminAuthControllerProvider.notifier).lock();
              }
            },
            child: Text(l10n.terminalAdmin),
          ),
        ],
      ),
      body: employeesAsync.when(
        data: (employees) {
          if (state.selectedEmployeeId == null) {
            return _EmployeeSelector(
              employees: employees,
              onSelect: (id) => ref
                  .read(terminalControllerProvider.notifier)
                  .selectEmployee(id),
            );
          }

          EmployeeInfo? employee;
          for (final e in employees) {
            if (e.id == state.selectedEmployeeId) {
              employee = e;
              break;
            }
          }
          if (employee == null) {
            // The employee might have been deactivated while selected.
            ref.read(terminalControllerProvider.notifier).clearSelection();
            return const SizedBox.shrink();
          }

          return _TerminalActions(employee: employee);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            l10n.terminalFailedLoadEmployees(l10n.commonErrorOccurred),
          ),
        ),
      ),
    );
  }
}

class _EmployeeSelector extends ConsumerWidget {
  const _EmployeeSelector({required this.employees, required this.onSelect});

  final List<EmployeeInfo> employees;
  final void Function(int employeeId) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final e = employees[index];
        return Card(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ListTile(
              title: Text(
                EmployeeDisplayName.of(
                  EmployeeDisplay(firstName: e.firstName, lastName: e.lastName),
                ),
              ),
              onTap: () => _onEmployeePressed(context, ref, e),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onEmployeePressed(
    BuildContext context,
    WidgetRef ref,
    EmployeeInfo e,
  ) async {
    final l10n = AppLocalizations.of(context);
    final authUseCase = ref.read(terminalEmployeeAuthUseCaseProvider);

    try {
      if (!e.usePin) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text(l10n.terminalPinNotSet),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.commonOk),
              ),
            ],
          ),
        );
        return;
      }

      final pinStatus = await authUseCase.getPinStatus(e.id);
      if (!context.mounted) return;
      if (pinStatus != EmployeePinStatus.set) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text(l10n.terminalPinNotSet),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.commonOk),
              ),
            ],
          ),
        );
        return;
      }

      await _showPinDialog(context, ref, authUseCase, e, onSelect);
    } catch (err, _) {
      debugPrint('[E] Terminal _onEmployeePressed: ${err.runtimeType}');
      if (context.mounted) {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text(
              l10n.terminalFailedLoadEmployees(l10n.commonErrorOccurred),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.commonOk),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _showPinDialog(
    BuildContext context,
    WidgetRef ref,
    TerminalEmployeeAuthUseCase authUseCase,
    EmployeeInfo employee,
    void Function(int employeeId) onSelect,
  ) async {
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _PinDialogContent(
        l10n: l10n,
        employeeId: employee.id,
        verifyPin: authUseCase.verifyEmployeePin,
        onSuccess: () async {
          if (employee.policyAcknowledged) {
            onSelect(employee.id);
          } else {
            final confirmed = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => _PolicyAcknowledgmentDialog(
                l10n: l10n,
                employeeId: employee.id,
                authUseCase: authUseCase,
                onConfirm: () => onSelect(employee.id),
              ),
            );
            if (confirmed != true && context.mounted) {
              ref.read(terminalControllerProvider.notifier).clearSelection();
            }
          }
        },
      ),
    );
  }
}

class _PinDialogContent extends StatefulWidget {
  const _PinDialogContent({
    required this.l10n,
    required this.employeeId,
    required this.verifyPin,
    required this.onSuccess,
  });

  final AppLocalizations l10n;
  final int employeeId;
  final Future<bool> Function({required int employeeId, required String pin})
  verifyPin;
  final VoidCallback onSuccess;

  @override
  State<_PinDialogContent> createState() => _PinDialogContentState();
}

class _PinDialogContentState extends State<_PinDialogContent> {
  late final TextEditingController _ctrl;
  String? _errorText;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _ctrl.text.trim();
    if (pin.isEmpty) return;
    if (_verifying) return;

    setState(() {
      _errorText = null;
      _verifying = true;
    });

    final ok = await widget.verifyPin(employeeId: widget.employeeId, pin: pin);

    if (!mounted) return;
    setState(() => _verifying = false);

    if (ok) {
      Navigator.of(context).pop();
      widget.onSuccess();
    } else {
      setState(() => _errorText = widget.l10n.changePinCurrentInvalid);
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.terminalPinPromptTitle),
      content: TextField(
        controller: _ctrl,
        obscureText: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        autofocus: true,
        enabled: !_verifying,
        decoration: InputDecoration(
          labelText: widget.l10n.adminPinLabel,
          errorText: _errorText,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: _verifying ? null : _cancel,
          child: Text(widget.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _verifying ? null : _submit,
          child: _verifying
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.l10n.terminalPinConfirm),
        ),
      ],
    );
  }
}

class _PolicyAcknowledgmentDialog extends StatefulWidget {
  const _PolicyAcknowledgmentDialog({
    required this.l10n,
    required this.employeeId,
    required this.authUseCase,
    required this.onConfirm,
  });

  final AppLocalizations l10n;
  final int employeeId;
  final TerminalEmployeeAuthUseCase authUseCase;
  final VoidCallback onConfirm;

  @override
  State<_PolicyAcknowledgmentDialog> createState() =>
      _PolicyAcknowledgmentDialogState();
}

class _PolicyAcknowledgmentDialogState
    extends State<_PolicyAcknowledgmentDialog> {
  bool _acknowledged = false;
  bool _saving = false;

  Future<void> _confirm() async {
    if (!_acknowledged || _saving) return;
    setState(() => _saving = true);
    try {
      await widget.authUseCase.updateEmployeePolicyAcknowledged(
        widget.employeeId,
        acknowledged: true,
        acknowledgedAt: UtcClock.nowMs(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      widget.onConfirm();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return AlertDialog(
      title: Text(l10n.terminalPolicyRequiredTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.terminalPolicyRequiredMessage),
            const SizedBox(height: 16),
            LegalLinks(
              privacyTitle: l10n.settingsPrivacyPolicy,
              termsTitle: l10n.legalTerms,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _acknowledged,
              onChanged: (v) => setState(() => _acknowledged = v ?? false),
              title: Text(
                l10n.terminalPolicyCheckboxText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _acknowledged && !_saving ? _confirm : null,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.commonOk),
        ),
      ],
    );
  }
}

class _TerminalActions extends ConsumerWidget {
  const _TerminalActions({required this.employee});

  final EmployeeInfo employee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final employeeId = employee.id;

    final openSessionAsync = ref.watch(
      watchOpenSessionForEmployeeProvider(employeeId),
    );
    final todaySessionsAsync = ref.watch(
      todaySessionsForEmployeeProvider(employeeId),
    );
    final workingHoursAsync = ref.watch(workingHoursSettingsProvider);
    final endMin = workingHoursAsync.value?.endMin ?? defaultWorkingHoursEndMin;

    return openSessionAsync.when(
      data: (open) {
        final isOpen = open != null;
        final openSession = open;
        final showCloseBlock =
            openSession != null && isPastWorkingDayEnd(openSession, endMin);

        if (showCloseBlock) {
          final session = openSession;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TerminalHeader(
                      employee: employee,
                      onBack: () => ref
                          .read(terminalControllerProvider.notifier)
                          .clearSelection(),
                      l10n: l10n,
                    ),
                    const SizedBox(height: 24),
                    _ClosePreviousSessionBlock(
                      employee: employee,
                      openSession: session,
                      endMin: endMin,
                    ),
                    const SizedBox(height: 24),
                    _TerminalTodaySessions(
                      sessionsAsync: todaySessionsAsync,
                      openSessionId: session.id,
                      l10n: l10n,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TerminalHeader(
                    employee: employee,
                    onBack: () => ref
                        .read(terminalControllerProvider.notifier)
                        .clearSelection(),
                    l10n: l10n,
                  ),
                  const SizedBox(height: 24),
                  _TerminalStatusCard(
                    isOnShift: isOpen,
                    sessionStartTime: open != null
                        ? TimeFormat.formatTimeOnly(open.startTs)
                        : null,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 24),
                  _TerminalActionButtons(
                    isOnShift: isOpen,
                    onClockIn: () => _handleClockIn(context, ref, employeeId),
                    onClockOut: () => _handleClockOut(context, ref, employeeId),
                    onMyCalendar: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EmployeeCalendarPage(
                          employeeId: employeeId,
                          employee: employee,
                        ),
                      ),
                    ),
                    onMyPdf: () => _handleMyPdf(context, ref, employee),
                    l10n: l10n,
                  ),
                  const SizedBox(height: 24),
                  _TerminalTodaySessions(
                    sessionsAsync: todaySessionsAsync,
                    openSessionId: open?.id,
                    l10n: l10n,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(l10n.terminalFailedLoadEmployees(l10n.commonErrorOccurred)),
      ),
    );
  }
}

/// Header with back action and employee name.
class _TerminalHeader extends StatelessWidget {
  const _TerminalHeader({
    required this.employee,
    required this.onBack,
    required this.l10n,
  });

  final EmployeeInfo employee;
  final VoidCallback onBack;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilledButton.tonal(
          onPressed: onBack,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            minimumSize: const Size(0, 48),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Symbols.arrow_back, size: 20),
              const SizedBox(width: 8),
              Text(l10n.commonBack),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            EmployeeDisplayName.of(
              EmployeeDisplay(
                firstName: employee.firstName,
                lastName: employee.lastName,
              ),
            ),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }
}

/// Status card showing current state (on shift / ready) and current time.
class _TerminalStatusCard extends StatelessWidget {
  const _TerminalStatusCard({
    required this.isOnShift,
    this.sessionStartTime,
    required this.l10n,
  });

  final bool isOnShift;
  final String? sessionStartTime;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOnShift ? Symbols.schedule : Symbols.timer,
                  size: 24,
                  color: isOnShift ? cs.primary : cs.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOnShift
                            ? l10n.terminalStatusOnShift
                            : l10n.terminalStatusReady,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isOnShift && sessionStartTime != null)
                        Text(
                          l10n.terminalOnShiftSince(sessionStartTime!),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.terminalCurrentTime(TimeFormat.formatNow()),
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Clock in/out action buttons with clear visual hierarchy.
class _TerminalActionButtons extends StatelessWidget {
  const _TerminalActionButtons({
    required this.isOnShift,
    required this.onClockIn,
    required this.onClockOut,
    required this.onMyCalendar,
    required this.onMyPdf,
    required this.l10n,
  });

  final bool isOnShift;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;
  final VoidCallback onMyCalendar;
  final VoidCallback onMyPdf;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _TerminalActionButton(
                icon: Symbols.login_rounded,
                label: l10n.terminalIn,
                isPrimary: !isOnShift,
                onPressed: isOnShift ? null : onClockIn,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TerminalActionButton(
                icon: Symbols.logout_rounded,
                label: l10n.terminalOut,
                isPrimary: isOnShift,
                onPressed: isOnShift ? onClockOut : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            onPressed: onMyCalendar,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              minimumSize: const Size(0, 48),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Symbols.calendar_month, size: 20),
                const SizedBox(width: 8),
                Text(l10n.terminalMyCalendar),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            onPressed: onMyPdf,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              minimumSize: const Size(0, 48),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Symbols.picture_as_pdf, size: 20),
                const SizedBox(width: 8),
                Text(l10n.terminalMyPdf),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TerminalActionButton extends StatelessWidget {
  const _TerminalActionButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    if (isPrimary) {
      return FilledButton(onPressed: onPressed, child: child);
    }
    return FilledButton.tonal(onPressed: onPressed, child: child);
  }
}

/// List of today's sessions for the current employee.
class _TerminalTodaySessions extends StatefulWidget {
  const _TerminalTodaySessions({
    required this.sessionsAsync,
    this.openSessionId,
    required this.l10n,
  });

  final AsyncValue<List<SessionInfo>> sessionsAsync;
  final int? openSessionId;
  final AppLocalizations l10n;

  @override
  State<_TerminalTodaySessions> createState() => _TerminalTodaySessionsState();
}

class _TerminalTodaySessionsState extends State<_TerminalTodaySessions> {
  bool _expanded = false;
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
    final l10n = widget.l10n;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return widget.sessionsAsync.when(
      data: (sessions) {
        if (sessions.isEmpty) return const SizedBox.shrink();

        final nowMs = DateTime.now().millisecondsSinceEpoch;
        final displaySessions = _expanded
            ? sessions
            : sessions.take(3).toList();
        final hasMore = sessions.length > 3;
        final hiddenCount = sessions.length - 3;

        var totalMin = 0;
        for (final s in sessions) {
          if (s.id == widget.openSessionId) {
            totalMin += minutesBetweenUtcMsClamp(s.startTs, nowMs);
          } else if (s.endTs != null) {
            totalMin += minutesBetweenUtcMsClamp(s.startTs, s.endTs!);
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.terminalSessionsToday,
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displaySessions.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final s = displaySessions[index];
                return _TerminalSessionRow(
                  session: s,
                  openSessionId: widget.openSessionId,
                  nowMs: nowMs,
                  l10n: l10n,
                  theme: theme,
                  cs: cs,
                );
              },
            ),
            if (hasMore && !_expanded)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextButton(
                  onPressed: () => setState(() => _expanded = true),
                  child: Text(l10n.terminalShowMoreSessions(hiddenCount)),
                ),
              ),
            if (sessions.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                l10n.terminalTotalTodayWithValue(
                  formatTerminalSessionDuration(l10n, totalMin),
                ),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _TerminalSessionRow extends StatelessWidget {
  const _TerminalSessionRow({
    required this.session,
    required this.openSessionId,
    required this.nowMs,
    required this.l10n,
    required this.theme,
    required this.cs,
  });

  final SessionInfo session;
  final int? openSessionId;
  final int nowMs;
  final AppLocalizations l10n;
  final ThemeData theme;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final isOpen = session.id == openSessionId;
    final start = TimeFormat.formatTimeOnly(session.startTs);
    final String trailing;
    if (isOpen) {
      trailing = formatTerminalSessionDuration(
        l10n,
        minutesBetweenUtcMsClamp(session.startTs, nowMs),
      );
    } else if (session.endTs != null) {
      trailing = formatTerminalSessionDuration(
        l10n,
        minutesBetweenUtcMsClamp(session.startTs, session.endTs!),
      );
    } else {
      trailing = l10n.commonOngoing;
    }
    final endStr = session.endTs != null
        ? TimeFormat.formatTimeOnly(session.endTs!)
        : '…';

    return Material(
      color: isOpen ? cs.primaryContainer.withValues(alpha: 0.5) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              isOpen ? Symbols.schedule : Symbols.check_circle,
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

/// Shows period selector dialog for "My PDF". Returns period or null if cancelled.
Future<({int fromUtcMs, int toUtcMs})?> _showMyPdfPeriodDialog(
  BuildContext context,
  AppLocalizations l10n,
) async {
  ({int fromUtcMs, int toUtcMs})? selected;
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.reportsPeriodLabel),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ListTile(
              title: Text(l10n.reportsPeriodPresetToday),
              onTap: () {
                selected = reportPeriodToday();
                Navigator.of(ctx).pop();
              },
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ListTile(
              title: Text(l10n.reportsPeriodPresetWeek),
              onTap: () {
                selected = reportPeriodWeek();
                Navigator.of(ctx).pop();
              },
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ListTile(
              title: Text(l10n.reportsPeriodPresetMonth),
              onTap: () {
                selected = reportPeriodMonth();
                Navigator.of(ctx).pop();
              },
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ListTile(
              title: Text(l10n.reportsPeriodPresetCustom),
              onTap: () async {
                final range = await pickDateRange(ctx);
                if (ctx.mounted && range != null) {
                  selected = range;
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
  return selected;
}

Future<void> _handleMyPdf(
  BuildContext context,
  WidgetRef ref,
  EmployeeInfo employee,
) async {
  final l10n = AppLocalizations.of(context);
  final period = await _showMyPdfPeriodDialog(context, l10n);
  if (period == null || !context.mounted) return;
  final ymd = trackingStartYmdFromWatch(
    ref.read(trackingStartSettingsProvider),
  );
  final clamped = clampUtcRangeToTrackingStart(
    fromUtcMs: period.fromUtcMs,
    toUtcMs: period.toUtcMs,
    trackingStartYmd: ymd,
  );
  final employeeName = EmployeeDisplayName.of(
    EmployeeDisplay(firstName: employee.firstName, lastName: employee.lastName),
  );
  final details = await ref
      .read(employeesAdminUseCaseProvider)
      .getEmployeeDetails(employee.id);
  final sbMs = startingBalanceMsForPeriod(
    tenths: details?.startingBalanceTenths,
    trackingStartYmd: ymd,
    balanceUpdatedAtUtcMs: details?.startingBalanceUpdatedAt,
    fromUtcMs: clamped.fromUtcMs,
    toUtcMs: clamped.toUtcMs,
  );
  if (!context.mounted) return;
  await exportEmployeeDailyPdf(
    context,
    dayReportUseCase: ref.read(employeeDayReportUseCaseProvider),
    employeeId: employee.id,
    employeeName: employeeName,
    fromUtcMs: clamped.fromUtcMs,
    toUtcMs: clamped.toUtcMs,
    sortColumnName: null,
    periodStartingBalanceMs: sbMs,
    showSnack: (msg) => showAppSnack(context, msg),
    showErrorSnack: (msg, {bool isError = false}) =>
        showAppSnack(context, msg, isError: isError),
  );
}

/// Returns attendance mode and tolerance when settings are loaded; otherwise
/// shows [l10n.terminalErrorAttendanceUnavailable] and returns null.
({AttendanceMode mode, int toleranceMinutes})?
_readAttendanceSettingsOrShowError(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) {
  final rawValue = ref.read(attendanceSettingsProvider).value;
  if (rawValue == null) {
    showAppSnack(
      context,
      l10n.terminalErrorAttendanceUnavailable,
      isError: true,
    );
    return null;
  }
  return rawValue;
}

Future<void> _handleClockIn(
  BuildContext context,
  WidgetRef ref,
  int employeeId, {
  String? note,
}) async {
  _appendTerminalDiagnosticUnawaited(event: DiagnosticEvent.terminalClockIn);
  final l10n = AppLocalizations.of(context);
  final attendance = _readAttendanceSettingsOrShowError(context, ref, l10n);
  if (attendance == null) return;
  final workingHours =
      ref.read(workingHoursSettingsProvider).value ??
      (
        startMin: defaultWorkingHoursStartMin,
        endMin: defaultWorkingHoursEndMin,
      );
  final now = DateTime.now();
  final nowMin = now.hour * 60 + now.minute;
  if (attendance.mode == AttendanceMode.flexible) {
    if (nowMin < workingHours.startMin) {
      showAppSnack(
        context,
        l10n.terminalErrorClockInBeforeStart,
        isError: true,
      );
      return;
    }
    if (nowMin > workingHours.endMin) {
      showAppSnack(context, l10n.terminalErrorClockInAfterEnd, isError: true);
      return;
    }
  }
  final result = await ref.read(clockInUseCaseProvider)(
    employeeId,
    note: note,
    attendanceMode: attendance.mode,
    toleranceMinutes: attendance.toleranceMinutes,
  );
  if (!context.mounted) return;
  if (result is ClockNeedsNote) {
    final submittedNote = await _showMandatoryNoteDialog(
      context,
      l10n,
      result.kind,
    );
    if (submittedNote != null && context.mounted) {
      await _handleClockIn(context, ref, employeeId, note: submittedNote);
    }
    return;
  }
  if (result is ClockSaved) {
    _appendTerminalDiagnosticUnawaited(
      event: DiagnosticEvent.terminalClockInSuccess,
    );
    await showDialog<void>(
      context: context,
      barrierColor: _clockSuccessBarrierColor(context),
      barrierDismissible: false,
      builder: (context) =>
          _ClockInSuccessDialog(message: l10n.terminalSuccessClockIn),
    );
    if (context.mounted) {
      ref.read(terminalControllerProvider.notifier).clearSelection();
    }
    return;
  }
  if (result case final ClockError err) {
    _showClockError(context, err, isClockIn: true);
  }
}

Future<void> _handleClockOut(
  BuildContext context,
  WidgetRef ref,
  int employeeId, {
  String? note,
}) async {
  _appendTerminalDiagnosticUnawaited(event: DiagnosticEvent.terminalClockOut);
  final l10nOut = AppLocalizations.of(context);
  final attendance = _readAttendanceSettingsOrShowError(context, ref, l10nOut);
  if (attendance == null) return;
  final result = await ref.read(clockOutUseCaseProvider)(
    employeeId,
    note: note,
    attendanceMode: attendance.mode,
    toleranceMinutes: attendance.toleranceMinutes,
  );
  if (!context.mounted) return;
  if (result is ClockNeedsNote) {
    final l10n = AppLocalizations.of(context);
    final submittedNote = await _showMandatoryNoteDialog(
      context,
      l10n,
      result.kind,
    );
    if (submittedNote != null && context.mounted) {
      await _handleClockOut(context, ref, employeeId, note: submittedNote);
    }
    return;
  }
  if (result is ClockSaved) {
    _appendTerminalDiagnosticUnawaited(
      event: DiagnosticEvent.terminalClockOutSuccess,
    );
    final l10n = AppLocalizations.of(context);
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => ColoredBox(
        color: _clockSuccessBarrierColor(context),
        child: Center(
          child: _AnimatedCheckmarkSuccess(
            message: l10n.terminalSuccessClockOut,
          ),
        ),
      ),
    );
    overlay.insert(entry);
    final notifier = ref.read(terminalControllerProvider.notifier);
    Future.delayed(const Duration(milliseconds: 1200), () {
      entry.remove();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.clearSelection();
      });
    });
    return;
  }
  if (result case final ClockError err) {
    _showClockError(context, err, isClockIn: false);
  }
}

/// Error snack for clock-in/out failures. Callers must only pass [ClockError]
/// (success and note-required paths are handled before this).
void _showClockError(
  BuildContext context,
  ClockError result, {
  required bool isClockIn,
}) {
  _appendTerminalDiagnosticUnawaited(
    event: isClockIn
        ? DiagnosticEvent.terminalClockInFail
        : DiagnosticEvent.terminalClockOutFail,
    errorType: result.kind.name,
  );
  final l10n = AppLocalizations.of(context);
  final text = switch (result.kind) {
    ClockErrorKind.sessionAlreadyOpen => l10n.terminalErrorSessionAlreadyOpen,
    ClockErrorKind.noOpenSession => l10n.terminalErrorNoOpenSession,
    ClockErrorKind.employeeInactive => l10n.employeeInactive,
    ClockErrorKind.hasApprovedAbsence => l10n.terminalErrorHasApprovedAbsence,
    ClockErrorKind.noScheduleForDay => l10n.terminalErrorNoScheduleForDay,
  };
  showAppSnack(context, text, isError: true);
}

String _reasonTextForNoteKind(AppLocalizations l10n, ClockNeedsNoteKind kind) {
  return switch (kind) {
    ClockNeedsNoteKind.lateCheckIn => l10n.terminalNoteReasonLateArrival,
    ClockNeedsNoteKind.earlyCheckOut => l10n.terminalNoteReasonEarlyDeparture,
    ClockNeedsNoteKind.lateCheckOut => l10n.terminalNoteReasonLateDeparture,
  };
}

Future<String?> _showMandatoryNoteDialog(
  BuildContext context,
  AppLocalizations l10n,
  ClockNeedsNoteKind kind,
) async {
  return showDialog<String?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _MandatoryNoteDialog(
      title: l10n.terminalNoteRequiredTitle,
      message: l10n.terminalNoteRequiredMessage,
      reasonLine: _reasonTextForNoteKind(l10n, kind),
      noteLabel: l10n.terminalNoteLabel,
      confirmLabel: l10n.terminalNoteConfirm,
      cancelLabel: l10n.terminalNoteCancel,
    ),
  );
}

class _MandatoryNoteDialog extends StatefulWidget {
  const _MandatoryNoteDialog({
    required this.title,
    required this.message,
    required this.reasonLine,
    required this.noteLabel,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  final String title;
  final String message;
  final String reasonLine;
  final String noteLabel;
  final String confirmLabel;
  final String cancelLabel;

  @override
  State<_MandatoryNoteDialog> createState() => _MandatoryNoteDialogState();
}

class _MandatoryNoteDialogState extends State<_MandatoryNoteDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.message),
          const SizedBox(height: 8),
          Text(
            widget.reasonLine,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: widget.noteLabel,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
            autofocus: true,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(widget.cancelLabel),
        ),
        FilledButton(
          onPressed: _controller.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

/// Reusable animated checkmark with optional message. Runs scale + fade on mount.
class _AnimatedCheckmarkSuccess extends StatefulWidget {
  const _AnimatedCheckmarkSuccess({required this.message});

  final String message;

  @override
  State<_AnimatedCheckmarkSuccess> createState() =>
      _AnimatedCheckmarkSuccessState();
}

class _AnimatedCheckmarkSuccessState extends State<_AnimatedCheckmarkSuccess>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: cs.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scale,
              child: FadeTransition(
                opacity: _opacity,
                child: Icon(Symbols.check_circle, size: 120, color: cs.primary),
              ),
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _opacity,
              child: Text(
                widget.message,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: cs.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog content that shows animated checkmark and pops after 1.2s.
class _ClockInSuccessDialog extends StatefulWidget {
  const _ClockInSuccessDialog({required this.message});

  final String message;

  @override
  State<_ClockInSuccessDialog> createState() => _ClockInSuccessDialogState();
}

class _ClockInSuccessDialogState extends State<_ClockInSuccessDialog> {
  static const _autoCloseDuration = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(_autoCloseDuration, () {
        if (mounted) Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: _AnimatedCheckmarkSuccess(message: widget.message));
  }
}

class _ClosePreviousSessionBlock extends ConsumerWidget {
  const _ClosePreviousSessionBlock({
    required this.employee,
    required this.openSession,
    required this.endMin,
  });

  final EmployeeInfo employee;
  final SessionInfo openSession;
  final int endMin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final startTimeStr = TimeFormat.formatLocalFromUtcMs(openSession.startTs);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Symbols.warning_amber_rounded,
                  size: 24,
                  color: cs.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.terminalUnclosedSessionTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        l10n.terminalUnclosedSessionMessage(startTimeStr),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _closeSessionWithPicker(
                  context,
                  ref: ref,
                  employee: employee,
                  openSession: openSession,
                  endMin: endMin,
                  l10n: l10n,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    l10n.terminalUnclosedSessionConfirm,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _closeSessionWithPicker(
    BuildContext context, {
    required WidgetRef ref,
    required EmployeeInfo employee,
    required SessionInfo openSession,
    required int endMin,
    required AppLocalizations l10n,
  }) async {
    final sessionStartLocal = DateTime.fromMillisecondsSinceEpoch(
      openSession.startTs,
      isUtc: true,
    ).toLocal();
    final sessionDate = DateTime(
      sessionStartLocal.year,
      sessionStartLocal.month,
      sessionStartLocal.day,
    );

    final date = await showDatePicker(
      context: context,
      firstDate: sessionDate,
      lastDate: sessionDate,
      initialDate: sessionDate,
    );
    if (date == null || !context.mounted) return;

    final result = await showDialog<DateTime?>(
      context: context,
      builder: (ctx) => _UnclosedSessionTimePickerDialog(
        sessionDate: date,
        openSessionStartTs: openSession.startTs,
        endMin: endMin,
        l10n: l10n,
      ),
    );
    if (result == null || !context.mounted) return;

    final endUtcMs = result.toUtc().millisecondsSinceEpoch;
    try {
      final ok = await ref.read(closeOpenSessionWithEndUseCaseProvider)(
        employeeId: employee.id,
        endUtcMs: endUtcMs,
      );
      if (!context.mounted) return;
      if (!ok) {
        showAppSnack(
          context,
          l10n.terminalUnclosedSessionErrorEndBeforeStart,
          isError: true,
        );
      }
    } on DomainValidationException catch (e) {
      if (!context.mounted) return;
      final msg = e.message == 'sessionsErrorSameDayRequired'
          ? l10n.sessionsErrorSameDayRequired
          : l10n.commonErrorOccurred;
      showAppSnack(context, msg, isError: true);
      return;
    } catch (e) {
      if (!context.mounted) return;
      showAppSnack(context, l10n.commonErrorOccurred, isError: true);
      return;
    }
  }
}

class _UnclosedSessionTimePickerDialog extends StatefulWidget {
  const _UnclosedSessionTimePickerDialog({
    required this.sessionDate,
    required this.openSessionStartTs,
    required this.endMin,
    required this.l10n,
  });

  final DateTime sessionDate;
  final int openSessionStartTs;
  final int endMin;
  final AppLocalizations l10n;

  @override
  State<_UnclosedSessionTimePickerDialog> createState() =>
      _UnclosedSessionTimePickerDialogState();
}

class _UnclosedSessionTimePickerDialogState
    extends State<_UnclosedSessionTimePickerDialog> {
  DateTime? _picked;
  String? _validationError;

  String? _validate(DateTime picked) {
    final endUtcMs = picked.toUtc().millisecondsSinceEpoch;
    if (endUtcMs <= widget.openSessionStartTs) {
      return widget.l10n.terminalUnclosedSessionErrorEndBeforeStart;
    }
    if (endUtcMs > UtcClock.nowMs()) {
      return widget.l10n.terminalUnclosedSessionErrorEndInFuture;
    }
    final pickedMin = picked.hour * 60 + picked.minute;
    if (pickedMin > widget.endMin) {
      return widget.l10n.terminalUnclosedSessionErrorEndAfterWorkingHours;
    }
    return null;
  }

  Future<void> _pickTime() async {
    final picked = await pickTimeForDate(
      context,
      date: widget.sessionDate,
      initialTime: TimeFormat.timeOfDayFromMinutes(widget.endMin),
    );
    if (picked == null || !mounted) return;
    final err = _validate(picked);
    setState(() {
      _validationError = err;
      _picked = err == null ? picked : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(l10n.terminalUnclosedSessionEndLabel),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_validationError != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.errorContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Symbols.error, size: 20, color: cs.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _validationError!,
                        style: TextStyle(
                          color: cs.onErrorContainer,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            OutlinedButton.icon(
              onPressed: _pickTime,
              icon: const Icon(Symbols.schedule),
              label: Text(
                _picked != null
                    ? TimeFormat.formatTimeOnly(
                        _picked!.toUtc().millisecondsSinceEpoch,
                      )
                    : l10n.terminalUnclosedSessionSelectEnd,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _picked != null
              ? () => Navigator.of(context).pop(_picked)
              : null,
          child: Text(l10n.terminalUnclosedSessionConfirm),
        ),
      ],
    );
  }
}
