import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/locale/locale_settings_controller.dart';
import '../../../app/theme/theme_settings_controller.dart';
import '../../../app/working_hours/working_hours_settings_controller.dart';
import '../../../common/utils/backup_error_messages.dart';
import '../../../common/utils/time_format.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../common/widgets/success_animation_overlay.dart';
import '../../../app/backup_providers.dart';
import '../../../app/diagnostic_export_providers.dart';
import '../../../core/diagnostic_log.dart';
import '../auth/change_pin_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final localeAsync = ref.watch(localeOverrideLanguageCodeProvider);
    final currentCode = localeAsync.valueOrNull; // null => system default
    final themeAsync = ref.watch(appThemeSelectionProvider);
    final themeSelection = themeAsync.valueOrNull ?? AppThemeSelection.system;
    final workingHoursAsync = ref.watch(workingHoursSettingsProvider);
    final workingHours = workingHoursAsync.valueOrNull;

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
                      final dropdownWidth = constraints.maxWidth -
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
                    final notifier =
                        ref.read(localeOverrideLanguageCodeProvider.notifier);
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
                      final dropdownWidth = constraints.maxWidth -
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
                        if (workingHours == null) return;
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeFormat.timeOfDayFromMinutes(
                              workingHours.startMin),
                        );
                        if (picked == null || !context.mounted) return;
                        final startMin =
                            picked.hour * 60 + picked.minute;
                        final notifier = ref.read(
                            workingHoursSettingsProvider.notifier);
                        final ok = await notifier.setWorkingHours(
                            startMin, workingHours.endMin);
                        if (context.mounted && !ok) {
                          showAppSnack(context,
                              l10n.settingsWorkingHoursInvalidRange,
                              isError: true);
                        }
                      },
                child: Text(
                    l10n.settingsWorkingHoursFromWithValue(
                        workingHours != null
                            ? TimeFormat.formatMinutes(workingHours.startMin)
                            : l10n.commonNotAvailable)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                onPressed: workingHoursAsync.isLoading
                    ? null
                    : () async {
                        if (workingHours == null) return;
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeFormat.timeOfDayFromMinutes(
                              workingHours.endMin),
                        );
                        if (picked == null || !context.mounted) return;
                        final endMin = picked.hour * 60 + picked.minute;
                        final notifier = ref.read(
                            workingHoursSettingsProvider.notifier);
                        final ok = await notifier.setWorkingHours(
                            workingHours.startMin, endMin);
                        if (context.mounted && !ok) {
                          showAppSnack(context,
                              l10n.settingsWorkingHoursInvalidRange,
                              isError: true);
                        }
                      },
                child: Text(
                    l10n.settingsWorkingHoursToWithValue(
                        workingHours != null
                            ? TimeFormat.formatMinutes(workingHours.endMin)
                            : l10n.commonNotAvailable)),
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
                icon: const Icon(Icons.lock_outline, size: 20),
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
                      icon: Icons.backup_rounded,
                    );
                  } else if (result.error != null) {
                    showAppSnack(context,
                        messageForBackupError(result.error!, l10n),
                        isError: true);
                  }
                },
                icon: const Icon(Icons.backup, size: 20),
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
                    showAppSnack(context,
                        messageForRestoreError(result.error!, l10n),
                        isError: true);
                  }
                },
                icon: const Icon(Icons.restore, size: 20),
                label: Text(l10n.settingsRestoreFromBackup),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  unawaited(DiagnosticLog.append(DiagnosticLogEntry(
                    event: DiagnosticEvent.diagnosticExportStart,
                    ts: DateTime.now().toUtc().toIso8601String(),
                  )));
                  final result =
                      await ref.read(exportDiagnosticsUseCaseProvider).exportToFile(context);
                  if (!context.mounted) return;
                  if (result.path != null) {
                    unawaited(DiagnosticLog.append(DiagnosticLogEntry(
                      event: DiagnosticEvent.diagnosticExportSuccess,
                      ts: DateTime.now().toUtc().toIso8601String(),
                    )));
                    showAppSnack(context, l10n.settingsExportDiagnosticsSuccess);
                  } else if (result.error != null) {
                    unawaited(DiagnosticLog.append(DiagnosticLogEntry(
                      event: DiagnosticEvent.diagnosticExportFail,
                      ts: DateTime.now().toUtc().toIso8601String(),
                      errorType: result.error,
                    )));
                    showAppSnack(context,
                        l10n.settingsExportDiagnosticsFailed(result.error!),
                        isError: true);
                  }
                },
                icon: const Icon(Icons.bug_report_outlined, size: 20),
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

