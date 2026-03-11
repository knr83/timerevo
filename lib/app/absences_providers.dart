import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/repo_providers.dart';
import '../domain/usecases.dart';

final watchAbsencesUseCaseProvider = Provider<WatchAbsencesUseCase>((ref) {
  return WatchAbsencesUseCase(ref.watch(absencesRepoProvider));
});

/// App-layer use case for absence CRUD and status updates. Use from UI instead of repo.
final absencesAdminUseCaseProvider = Provider<AbsencesAdminUseCase>((ref) {
  return AbsencesAdminUseCase(ref.watch(absencesRepoProvider));
});
