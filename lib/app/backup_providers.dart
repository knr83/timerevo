import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/db_providers.dart';
import '../data/services/backup_service.dart';
import 'backup_restore_usecase.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(appDbProvider));
});

/// App-layer boundary. Use this from UI instead of backupServiceProvider.
final backupRestoreUseCaseProvider = Provider<BackupRestoreUseCase>((ref) {
  return BackupRestoreUseCase(ref.watch(backupServiceProvider));
});
