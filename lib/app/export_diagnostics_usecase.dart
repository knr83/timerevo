import 'package:flutter/material.dart';

import '../data/services/diagnostic_export_service.dart';

/// App-layer boundary for diagnostics export.
/// UI uses this instead of importing data services directly.
class ExportDiagnosticsUseCase {
  ExportDiagnosticsUseCase();

  /// Exports diagnostics ZIP. Returns (path, null) on success, (null, error) on failure, (null, null) if cancelled.
  Future<({String? path, String? error})> exportToFile(BuildContext context) {
    return DiagnosticExportService.exportToFile(context);
  }
}
