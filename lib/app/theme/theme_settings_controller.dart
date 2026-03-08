import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/repo_providers.dart';

enum AppThemeSelection {
  system,
  light,
  dark,
  highContrastLight,
  highContrastDark,
}

final appThemeSelectionProvider =
    AsyncNotifierProvider<AppThemeSelectionController, AppThemeSelection>(
  AppThemeSelectionController.new,
);

class AppThemeSelectionController extends AsyncNotifier<AppThemeSelection> {
  @override
  FutureOr<AppThemeSelection> build() async {
    final repo = ref.read(themeSettingsRepoProvider);
    final raw = await repo.readSelection();
    return _parse(raw) ?? AppThemeSelection.system;
  }

  Future<void> setSelection(AppThemeSelection selection) async {
    final repo = ref.read(themeSettingsRepoProvider);
    state = const AsyncLoading();
    await repo.writeSelection(_serialize(selection));
    state = AsyncData(selection);
  }
}

AppThemeSelection? _parse(String? raw) {
  final v = raw?.trim().toLowerCase();
  if (v == null || v.isEmpty) return null;
  return switch (v) {
    'system' => AppThemeSelection.system,
    'light' => AppThemeSelection.light,
    'dark' => AppThemeSelection.dark,
    'hc_light' => AppThemeSelection.highContrastLight,
    'hc_dark' => AppThemeSelection.highContrastDark,
    _ => null,
  };
}

String _serialize(AppThemeSelection selection) {
  return switch (selection) {
    AppThemeSelection.system => 'system',
    AppThemeSelection.light => 'light',
    AppThemeSelection.dark => 'dark',
    AppThemeSelection.highContrastLight => 'hc_light',
    AppThemeSelection.highContrastDark => 'hc_dark',
  };
}

