import 'package:timerevo/l10n/app_localizations.dart';

/// Localized message for a stable absence domain error key
/// ([DomainValidationException.message] from the absences flow).
///
/// Unknown keys resolve to [AppLocalizations.commonErrorOccurred] so raw keys
/// are never shown to users.
String absenceDomainMessageForKey(String key, AppLocalizations l10n) {
  return switch (key) {
    'absenceErrorDeletePendingOnly' => l10n.absenceErrorDeletePendingOnly,
    'absenceErrorEditPendingOnly' => l10n.absenceErrorEditPendingOnly,
    'absenceErrorApproveRejectPendingOnly' =>
      l10n.absenceErrorApproveRejectPendingOnly,
    'absenceErrorRejectReasonRequired' => l10n.absenceErrorRejectReasonRequired,
    'absenceErrorDateOrder' => l10n.absenceErrorDateOrder,
    'absenceErrorOutsideEmployment' => l10n.absenceErrorOutsideEmployment,
    'absenceErrorOverlap' => l10n.absenceErrorOverlap,
    'absenceErrorDateRestrictionVacation' =>
      l10n.absenceErrorDateRestrictionVacation,
    'absenceErrorDateRestrictionSickLeave' =>
      l10n.absenceErrorDateRestrictionSickLeave,
    _ => l10n.commonErrorOccurred,
  };
}
