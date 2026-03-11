import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'export_diagnostics_usecase.dart';

final exportDiagnosticsUseCaseProvider = Provider<ExportDiagnosticsUseCase>((
  ref,
) {
  return ExportDiagnosticsUseCase();
});
