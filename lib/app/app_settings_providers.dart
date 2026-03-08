import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/repo_providers.dart';

const _legalNoticeSeenKey = 'legal_notice_seen';

/// App-level provider for legal notice visibility. Admin shell uses this
/// instead of directly accessing appSettingsRepoProvider.
final legalNoticeControllerProvider = Provider<LegalNoticeController>((ref) {
  final repo = ref.watch(appSettingsRepoProvider);
  return LegalNoticeController(repo);
});

/// Exposes only get/set for legal notice seen flag.
class LegalNoticeController {
  LegalNoticeController(this._repo);

  final dynamic _repo; // AppSettingsRepo

  Future<bool> hasSeenLegalNotice() async {
    return (await _repo.get(_legalNoticeSeenKey)) == '1';
  }

  Future<void> markLegalNoticeSeen() async {
    await _repo.set(_legalNoticeSeenKey, '1');
  }
}
