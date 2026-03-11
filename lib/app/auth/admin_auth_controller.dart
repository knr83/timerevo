import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/diagnostic_log.dart';
import '../../core/pin_validation.dart';
import '../../data/repositories/repo_providers.dart';

class AdminAuthState {
  const AdminAuthState({required this.isUnlocked, this.lastError});

  final bool isUnlocked;
  final String? lastError;

  AdminAuthState copyWith({bool? isUnlocked, String? lastError}) {
    return AdminAuthState(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      lastError: lastError,
    );
  }

  static const locked = AdminAuthState(isUnlocked: false);
}

class AdminAuthController extends Notifier<AdminAuthState> {
  @override
  AdminAuthState build() {
    return AdminAuthState.locked;
  }

  Future<bool> unlockWithPin(
    String pin, {
    String? invalidPinMessage,
    String? invalidFormatMessage,
  }) async {
    if (!isValidAdminPinFormat(pin)) {
      unawaited(
        DiagnosticLog.append(
          DiagnosticLogEntry(
            event: DiagnosticEvent.adminUnlockFail,
            ts: DateTime.now().toUtc().toIso8601String(),
          ),
        ),
      );
      final msg = invalidFormatMessage ?? invalidPinMessage ?? 'Invalid PIN.';
      SchedulerBinding.instance.addPostFrameCallback((_) {
        state = state.copyWith(isUnlocked: false, lastError: msg);
      });
      return false;
    }
    final ok = await ref.read(authRepoProvider).verifyAdminPin(pin: pin);
    if (!ok) {
      unawaited(
        DiagnosticLog.append(
          DiagnosticLogEntry(
            event: DiagnosticEvent.adminUnlockFail,
            ts: DateTime.now().toUtc().toIso8601String(),
          ),
        ),
      );
      final msg = invalidPinMessage ?? 'Invalid PIN.';
      SchedulerBinding.instance.addPostFrameCallback((_) {
        state = state.copyWith(isUnlocked: false, lastError: msg);
      });
      return false;
    }
    unawaited(
      DiagnosticLog.append(
        DiagnosticLogEntry(
          event: DiagnosticEvent.adminUnlockSuccess,
          ts: DateTime.now().toUtc().toIso8601String(),
        ),
      ),
    );
    state = state.copyWith(isUnlocked: true, lastError: null);
    return true;
  }

  void lock() {
    state = AdminAuthState.locked;
  }
}

final adminAuthControllerProvider =
    NotifierProvider<AdminAuthController, AdminAuthState>(
      AdminAuthController.new,
    );
