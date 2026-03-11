import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'core/diagnostic_log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru');
  await initializeDateFormatting('en');
  await initializeDateFormatting('de');

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    unawaited(
      DiagnosticLog.append(
        DiagnosticLogEntry(
          event: DiagnosticEvent.appFlutterError,
          ts: DateTime.now().toUtc().toIso8601String(),
          errorType: details.exception.runtimeType.toString(),
        ),
      ),
    );
  };

  runZonedGuarded(() => runApp(const ProviderScope(child: App())), (
    error,
    stackTrace,
  ) {
    unawaited(
      DiagnosticLog.append(
        DiagnosticLogEntry(
          event: DiagnosticEvent.appUnhandledError,
          ts: DateTime.now().toUtc().toIso8601String(),
          errorType: error.runtimeType.toString(),
        ),
      ),
    );
  });
}
