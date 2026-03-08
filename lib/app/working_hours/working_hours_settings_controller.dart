import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/repo_providers.dart';

/// Default: 6:00 = 360, 21:00 = 1260 (minutes from midnight).
const int defaultWorkingHoursStartMin = 360;
const int defaultWorkingHoursEndMin = 1260;

final workingHoursSettingsProvider =
    AsyncNotifierProvider<WorkingHoursSettingsController,
        ({int startMin, int endMin})>(WorkingHoursSettingsController.new);

class WorkingHoursSettingsController
    extends AsyncNotifier<({int startMin, int endMin})> {
  @override
  FutureOr<({int startMin, int endMin})> build() async {
    final repo = ref.read(workingHoursSettingsRepoProvider);
    final stored = await repo.read();
    return (
      startMin: stored.startMin ?? defaultWorkingHoursStartMin,
      endMin: stored.endMin ?? defaultWorkingHoursEndMin,
    );
  }

  Future<bool> setWorkingHours(int startMin, int endMin) async {
    if (startMin >= endMin) return false;
    if (startMin < 0 || startMin > 1439 || endMin < 0 || endMin > 1439) {
      return false;
    }
    final repo = ref.read(workingHoursSettingsRepoProvider);
    state = const AsyncLoading();
    await repo.write(startMin: startMin, endMin: endMin);
    state = AsyncData((startMin: startMin, endMin: endMin));
    return true;
  }
}
