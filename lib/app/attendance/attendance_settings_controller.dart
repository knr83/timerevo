import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/attendance_mode.dart';
import '../../data/repositories/repo_providers.dart';

final attendanceSettingsProvider =
    AsyncNotifierProvider<AttendanceSettingsController,
        ({AttendanceMode mode, int toleranceMinutes})>(
  AttendanceSettingsController.new,
);

class AttendanceSettingsController
    extends AsyncNotifier<({AttendanceMode mode, int toleranceMinutes})> {
  @override
  FutureOr<({AttendanceMode mode, int toleranceMinutes})> build() async {
    final repo = ref.read(attendanceSettingsRepoProvider);
    return repo.read();
  }

  Future<bool> setMode(AttendanceMode mode) async {
    final repo = ref.read(attendanceSettingsRepoProvider);
    state = const AsyncLoading();
    await repo.writeMode(mode);
    final current = await build();
    state = AsyncData(current);
    return true;
  }

  Future<bool> setTolerance(int toleranceMinutes) async {
    if (toleranceMinutes < 0) return false;
    final repo = ref.read(attendanceSettingsRepoProvider);
    state = const AsyncLoading();
    await repo.writeTolerance(toleranceMinutes);
    final current = await build();
    state = AsyncData(current);
    return true;
  }

  Future<bool> set({
    required AttendanceMode mode,
    required int toleranceMinutes,
  }) async {
    if (toleranceMinutes < 0) return false;
    final repo = ref.read(attendanceSettingsRepoProvider);
    state = const AsyncLoading();
    await repo.write(mode: mode, toleranceMinutes: toleranceMinutes);
    state = AsyncData((mode: mode, toleranceMinutes: toleranceMinutes));
    return true;
  }
}
