import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tracking_start_range_clamp.dart';
import '../../data/repositories/repo_providers.dart';

final trackingStartSettingsProvider =
    AsyncNotifierProvider<TrackingStartSettingsController, String?>(
      TrackingStartSettingsController.new,
    );

/// Resolves stored YYYY-MM-DD while loading/error yield null (no clamp).
String? trackingStartYmdFromWatch(AsyncValue<String?> async) {
  return async.when(data: (v) => v, loading: () => null, error: (_, _) => null);
}

class TrackingStartSettingsController extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() async {
    final repo = ref.read(trackingStartSettingsRepoProvider);
    return repo.read();
  }

  /// Persists [ymd] as `YYYY-MM-DD`, or clears when null.
  Future<void> set(String? ymd) async {
    if (ymd != null) {
      if (!_isValidYmd(ymd)) {
        return;
      }
      // Ensure parseable by clamp helper
      try {
        trackingStartLocalDayStartUtcMsFromYmd(ymd);
      } on FormatException {
        return;
      }
    }
    final repo = ref.read(trackingStartSettingsRepoProvider);
    state = const AsyncLoading();
    await repo.write(ymd);
    state = AsyncData(ymd);
  }

  bool _isValidYmd(String s) {
    final parts = s.split('-');
    if (parts.length != 3) return false;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return false;
    if (m < 1 || m > 12 || d < 1 || d > 31) return false;
    final dt = DateTime(y, m, d);
    if (dt.year != y || dt.month != m || dt.day != d) return false;
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    if (dt.isAfter(todayNorm)) return false;
    return true;
  }
}
