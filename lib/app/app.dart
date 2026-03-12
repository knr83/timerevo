import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import '../data/db/db_providers.dart';
import '../data/services/backup_service.dart';
import '../features/admin/admin_shell.dart';
import '../features/terminal/terminal_page.dart';
import 'app_init.dart';
import 'restore_completed_gate.dart';
import 'locale/locale_settings_controller.dart';
import 'theme/app_theme_builder.dart';
import 'theme/theme_settings_controller.dart';
import '../core/diagnostic_log.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(appInitProvider);
    final overrideAsync = ref.watch(localeOverrideLanguageCodeProvider);
    final overrideCode = overrideAsync.value;
    final themeSelectionAsync = ref.watch(appThemeSelectionProvider);
    final themeSelection =
        themeSelectionAsync.value ?? AppThemeSelection.system;
    final themeConfig = buildAppTheme(themeSelection);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: themeConfig.theme,
      darkTheme: themeConfig.darkTheme,
      highContrastTheme: themeConfig.highContrastTheme,
      highContrastDarkTheme: themeConfig.highContrastDarkTheme,
      themeMode: themeConfig.themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('de'), Locale('ru'), Locale('en')],
      locale: overrideCode == null ? null : Locale(overrideCode),
      localeResolutionCallback: (locale, supportedLocales) {
        final code = locale?.languageCode.toLowerCase();
        if (code == 'de' || code == 'ru' || code == 'en') {
          return Locale(code!);
        }
        return const Locale('de');
      },
      initialRoute: AppRoutes.terminal,
      routes: {
        AppRoutes.terminal: (_) =>
            const RestoreCompletedGate(child: TerminalPage()),
        AppRoutes.admin: (_) => const RestoreCompletedGate(child: AdminShell()),
      },
      onGenerateRoute: (settings) {
        // Fallback for unexpected route names.
        final name = settings.name;
        if (name == AppRoutes.admin) {
          return MaterialPageRoute(
            builder: (_) => const RestoreCompletedGate(child: AdminShell()),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const RestoreCompletedGate(child: TerminalPage()),
        );
      },
      builder: (context, child) {
        return init.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) {
            final l10n = AppLocalizations.of(context);
            debugPrint('[E] App init error: ${e.runtimeType}');
            unawaited(
              DiagnosticLog.append(
                DiagnosticLogEntry(
                  event: DiagnosticEvent.appInitFailed,
                  ts: DateTime.now().toUtc().toIso8601String(),
                  errorType: e.runtimeType.toString(),
                ),
              ),
            );
            final errStr = e.toString().toLowerCase();
            final isDbError =
                errStr.contains('sqlite') ||
                errStr.contains('database') ||
                errStr.contains('unable to open');
            if (isDbError) {
              return Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.initDbErrorTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.initDbErrorMessage),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () async {
                            final result = await BackupService.performRestore(
                              context,
                            );
                            if (result.success &&
                                result.needsRestart &&
                                context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.settingsRestoreScheduledRestart,
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.restore),
                          label: Text(l10n.initDbErrorRestore),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await BackupService.deleteDatabaseFiles();
                            ref.invalidate(appDbProvider);
                            ref.invalidate(appInitProvider);
                          },
                          icon: const Icon(Icons.delete_forever),
                          label: Text(l10n.initDbErrorReinitialize),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            ref.invalidate(appInitProvider);
                          },
                          child: Text(l10n.initDbErrorRetry),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Scaffold(body: Center(child: Text(l10n.initFailedGeneric)));
          },
          data: (_) => child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
