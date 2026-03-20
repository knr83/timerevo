import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/attendance/attendance_settings_controller.dart';
import '../../../app/locale/locale_settings_controller.dart';
import '../../../app/theme/theme_settings_controller.dart';
import '../../../app/tracking_start/tracking_start_settings_controller.dart';
import '../../../app/working_hours/working_hours_settings_controller.dart';
import '../../../core/attendance_mode.dart';
import '../../../common/utils/backup_error_messages.dart';
import '../../../common/utils/date_utils.dart';
import '../../../common/utils/time_format.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../common/widgets/success_animation_overlay.dart';
import '../../../app/backup_providers.dart';
import '../../../app/diagnostic_export_providers.dart';
import '../../../core/diagnostic_log.dart';
import '../auth/change_pin_dialog.dart';

class _ToleranceField extends StatefulWidget {
  const _ToleranceField({
    required this.initialValue,
    required this.label,
    required this.onSave,
  });

  final int initialValue;
  final String label;
  final void Function(int) onSave;

  @override
  State<_ToleranceField> createState() => _ToleranceFieldState();
}

class _ToleranceFieldState extends State<_ToleranceField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void didUpdateWidget(covariant _ToleranceField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onSubmitted: (v) {
        final n = int.tryParse(v);
        if (n != null && n >= 0) {
          widget.onSave(n);
        }
      },
    );
  }
}

class _AttendanceModeSection extends ConsumerWidget {
  const _AttendanceModeSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceSettingsProvider);
    final attendance = attendanceAsync.value;

    if (attendance == null) {
      return const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    const toleranceFieldWidth = 150.0;

    final children = <Widget>[
      Expanded(
        child: SegmentedButton<AttendanceMode>(
          segments: [
            ButtonSegment(
              value: AttendanceMode.flexible,
              label: Text(l10n.settingsAttendanceModeFlexible),
            ),
            ButtonSegment(
              value: AttendanceMode.fixed,
              label: Text(l10n.settingsAttendanceModeFixed),
            ),
          ],
          selected: {attendance.mode},
          onSelectionChanged: (selected) async {
            final newMode = selected.first;
            if (newMode == attendance.mode) return;
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(l10n.settingsAttendanceModeChangeConfirmTitle),
                content: Text(l10n.settingsAttendanceModeChangeConfirmMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(l10n.commonCancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(l10n.commonOk),
                  ),
                ],
              ),
            );
            if (confirmed == true && context.mounted) {
              await ref
                  .read(attendanceSettingsProvider.notifier)
                  .setMode(newMode);
            }
          },
        ),
      ),
      if (attendance.mode == AttendanceMode.fixed) ...[
        const SizedBox(width: 12),
        SizedBox(
          width: toleranceFieldWidth,
          child: _ToleranceField(
            initialValue: attendance.toleranceMinutes,
            label: l10n.settingsAttendanceToleranceLabel,
            onSave: (n) =>
                ref.read(attendanceSettingsProvider.notifier).setTolerance(n),
          ),
        ),
      ],
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final localeAsync = ref.watch(localeOverrideLanguageCodeProvider);
    final currentCode = localeAsync.value; // null => system default
    final themeAsync = ref.watch(appThemeSelectionProvider);
    final themeSelection = themeAsync.value ?? AppThemeSelection.system;
    final workingHoursAsync = ref.watch(workingHoursSettingsProvider);
    final workingHours = workingHoursAsync.value;

    const formMaxWidth = 360.0;
    const formMinWidth = 280.0;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: formMinWidth,
                maxWidth: formMaxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.settingsTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final dropdownWidth =
                          constraints.maxWidth -
                          8 -
                          (localeAsync.isLoading ? 16 : 0);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: dropdownWidth,
                            child: DropdownMenu<String?>(
                              expandedInsets: EdgeInsets.zero,
                              label: Text(l10n.settingsLanguageLabel),
                              initialSelection: currentCode,
                              dropdownMenuEntries: [
                                DropdownMenuEntry<String?>(
                                  value: null,
                                  label: l10n.settingsLanguageSystem,
                                ),
                                DropdownMenuEntry<String?>(
                                  value: 'de',
                                  label: l10n.settingsLanguageGerman,
                                ),
                                DropdownMenuEntry<String?>(
                                  value: 'ru',
                                  label: l10n.settingsLanguageRussian,
                                ),
                                DropdownMenuEntry<String?>(
                                  value: 'en',
                                  label: l10n.settingsLanguageEnglish,
                                ),
                              ],
                              onSelected: (value) async {
                                final notifier = ref.read(
                                  localeOverrideLanguageCodeProvider.notifier,
                                );
                                if (value == null) {
                                  await notifier.setSystemDefault();
                                } else {
                                  await notifier.setLanguageCode(value);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (localeAsync.isLoading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final dropdownWidth =
                          constraints.maxWidth -
                          8 -
                          (themeAsync.isLoading ? 16 : 0);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: dropdownWidth,
                            child: DropdownMenu<AppThemeSelection>(
                              expandedInsets: EdgeInsets.zero,
                              label: Text(l10n.settingsThemeLabel),
                              initialSelection: themeSelection,
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: AppThemeSelection.system,
                                  label: l10n.settingsThemeSystem,
                                ),
                                DropdownMenuEntry(
                                  value: AppThemeSelection.light,
                                  label: l10n.settingsThemeLight,
                                ),
                                DropdownMenuEntry(
                                  value: AppThemeSelection.dark,
                                  label: l10n.settingsThemeDark,
                                ),
                                DropdownMenuEntry(
                                  value: AppThemeSelection.highContrastLight,
                                  label: l10n.settingsThemeHighContrastLight,
                                ),
                                DropdownMenuEntry(
                                  value: AppThemeSelection.highContrastDark,
                                  label: l10n.settingsThemeHighContrastDark,
                                ),
                              ],
                              onSelected: (value) async {
                                if (value == null) return;
                                await ref
                                    .read(appThemeSelectionProvider.notifier)
                                    .setSelection(value);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (themeAsync.isLoading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsAttendanceModeLabel,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _AttendanceModeSection(l10n: l10n),
                  const SizedBox(height: 16),
                  Text(
                    l10n.settingsWorkingHoursLabel,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: workingHoursAsync.isLoading
                              ? null
                              : () async {
                                  if (workingHours == null) {
                                    return;
                                  }
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeFormat.timeOfDayFromMinutes(
                                          workingHours.startMin,
                                        ),
                                  );
                                  if (picked == null || !context.mounted) {
                                    return;
                                  }
                                  final startMin =
                                      picked.hour * 60 + picked.minute;
                                  final notifier = ref.read(
                                    workingHoursSettingsProvider.notifier,
                                  );
                                  final ok = await notifier.setWorkingHours(
                                    startMin,
                                    workingHours.endMin,
                                  );
                                  if (context.mounted && !ok) {
                                    showAppSnack(
                                      context,
                                      l10n.settingsWorkingHoursInvalidRange,
                                      isError: true,
                                    );
                                  }
                                },
                          child: Text(
                            l10n.settingsWorkingHoursFromWithValue(
                              workingHours != null
                                  ? TimeFormat.formatMinutes(
                                      workingHours.startMin,
                                    )
                                  : l10n.commonNotAvailable,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: workingHoursAsync.isLoading
                              ? null
                              : () async {
                                  if (workingHours == null) {
                                    return;
                                  }
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeFormat.timeOfDayFromMinutes(
                                          workingHours.endMin,
                                        ),
                                  );
                                  if (picked == null || !context.mounted) {
                                    return;
                                  }
                                  final endMin =
                                      picked.hour * 60 + picked.minute;
                                  final notifier = ref.read(
                                    workingHoursSettingsProvider.notifier,
                                  );
                                  final ok = await notifier.setWorkingHours(
                                    workingHours.startMin,
                                    endMin,
                                  );
                                  if (context.mounted && !ok) {
                                    showAppSnack(
                                      context,
                                      l10n.settingsWorkingHoursInvalidRange,
                                      isError: true,
                                    );
                                  }
                                },
                          child: Text(
                            l10n.settingsWorkingHoursToWithValue(
                              workingHours != null
                                  ? TimeFormat.formatMinutes(
                                      workingHours.endMin,
                                    )
                                  : l10n.commonNotAvailable,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (workingHoursAsync.isLoading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.settingsTrackingStartDateLabel,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  const _TrackingStartDateSection(),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => const ChangePinDialog(),
                      );
                      if (ok == true && context.mounted) {
                        showAppSnack(context, l10n.adminPinUpdated);
                      }
                    },
                    icon: const Icon(Symbols.lock, size: 20),
                    label: Text(l10n.adminChangePin),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await ref
                          .read(backupRestoreUseCaseProvider)
                          .createBackupToFolder();
                      if (!context.mounted) return;
                      if (result.path != null) {
                        await showSuccessAnimationDialog(
                          context,
                          message: l10n.settingsBackupSuccessTitle,
                          icon: Symbols.backup_rounded,
                        );
                      } else if (result.error != null) {
                        showAppSnack(
                          context,
                          messageForBackupError(result.error!, l10n),
                          isError: true,
                        );
                      }
                    },
                    icon: const Icon(Symbols.backup, size: 20),
                    label: Text(l10n.settingsCreateBackup),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await ref
                          .read(backupRestoreUseCaseProvider)
                          .restoreFromBackup(context, ref);
                      if (!context.mounted) return;
                      if (result.success) {
                        showAppSnack(
                          context,
                          result.needsRestart
                              ? l10n.settingsRestoreScheduledRestart
                              : l10n.settingsRestoreCreated,
                        );
                      } else if (result.error != null) {
                        showAppSnack(
                          context,
                          messageForRestoreError(result.error!, l10n),
                          isError: true,
                        );
                      }
                    },
                    icon: const Icon(Symbols.restore, size: 20),
                    label: Text(l10n.settingsRestoreFromBackup),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      unawaited(
                        DiagnosticLog.append(
                          DiagnosticLogEntry(
                            event: DiagnosticEvent.diagnosticExportStart,
                            ts: DateTime.now().toUtc().toIso8601String(),
                          ),
                        ),
                      );
                      final result = await ref
                          .read(exportDiagnosticsUseCaseProvider)
                          .exportToFile(context);
                      if (!context.mounted) return;
                      if (result.path != null) {
                        unawaited(
                          DiagnosticLog.append(
                            DiagnosticLogEntry(
                              event: DiagnosticEvent.diagnosticExportSuccess,
                              ts: DateTime.now().toUtc().toIso8601String(),
                            ),
                          ),
                        );
                        showAppSnack(
                          context,
                          l10n.settingsExportDiagnosticsSuccess,
                        );
                      } else if (result.error != null) {
                        unawaited(
                          DiagnosticLog.append(
                            DiagnosticLogEntry(
                              event: DiagnosticEvent.diagnosticExportFail,
                              ts: DateTime.now().toUtc().toIso8601String(),
                              errorType: result.error,
                            ),
                          ),
                        );
                        showAppSnack(
                          context,
                          l10n.settingsExportDiagnosticsFailed(result.error!),
                          isError: true,
                        );
                      }
                    },
                    icon: const Icon(Symbols.bug_report, size: 20),
                    label: Text(l10n.settingsExportDiagnostics),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingStartDateSection extends ConsumerWidget {
  const _TrackingStartDateSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(trackingStartSettingsProvider);
    return async.when(
      data: (ymd) {
        return Tooltip(
          message: l10n.settingsTrackingStartDateHelp,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final today = DateTime.now();
                    final todayNorm = DateTime(
                      today.year,
                      today.month,
                      today.day,
                    );
                    late DateTime initial;
                    if (ymd != null) {
                      final parts = ymd.split('-');
                      if (parts.length == 3) {
                        initial = DateTime(
                          int.parse(parts[0]),
                          int.parse(parts[1]),
                          int.parse(parts[2]),
                        );
                      } else {
                        initial = todayNorm;
                      }
                    } else {
                      initial = todayNorm;
                    }
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: DateTime(2000),
                      lastDate: todayNorm,
                    );
                    if (picked == null || !context.mounted) return;
                    final s = dateToYmd(picked);
                    await ref
                        .read(trackingStartSettingsProvider.notifier)
                        .set(s);
                  },
                  child: Text(ymd ?? l10n.settingsTrackingStartDateUnset),
                ),
              ),
              if (ymd != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => ref
                      .read(trackingStartSettingsProvider.notifier)
                      .set(null),
                  child: Text(l10n.settingsTrackingStartDateClear),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        height: 40,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, _) => Text(l10n.commonErrorOccurred),
    );
  }
}
