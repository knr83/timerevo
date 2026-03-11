import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../../app/absences_providers.dart';
import '../../../common/utils/date_utils.dart';
import '../../../common/utils/employee_display_name.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../core/domain_errors.dart';
import '../../../domain/entities/absence_info.dart';
import '../../../domain/entities/employee_display.dart';
import '../../../domain/entities/employee_info.dart';

const _absenceTypes = [
  ('vacation', 'absenceTypeVacation'),
  ('sick_leave', 'absenceTypeSickLeave'),
  ('unpaid_leave', 'absenceTypeUnpaidLeave'),
  ('parental_leave', 'absenceTypeParentalLeave'),
  ('study_leave', 'absenceTypeStudyLeave'),
  ('other', 'absenceTypeOther'),
];

Future<DateTime?> _pickDate(
  BuildContext context, {
  DateTime? firstDate,
  DateTime? initialDate,
}) async {
  final now = DateTime.now();
  final first = firstDate ?? DateTime(now.year - 1);
  final last = DateTime(now.year + 2);
  var initial = initialDate ?? now;
  if (initial.isBefore(first)) initial = first;
  if (initial.isAfter(last)) initial = last;
  return showDatePicker(
    context: context,
    firstDate: first,
    lastDate: last,
    initialDate: initial,
  );
}

class AbsenceRequestDialog extends ConsumerStatefulWidget {
  const AbsenceRequestDialog({
    super.key,
    this.existing,
    this.employeeId,
    required this.isAdminContext,
    required this.employees,
    this.onSaved,
  });

  final AbsenceInfo? existing;
  final int? employeeId;
  final bool isAdminContext;
  final List<EmployeeInfo> employees;
  final VoidCallback? onSaved;

  @override
  ConsumerState<AbsenceRequestDialog> createState() =>
      _AbsenceRequestDialogState();
}

class _AbsenceRequestDialogState extends ConsumerState<AbsenceRequestDialog> {
  int? _selectedEmployeeId;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String _type = 'vacation';
  final _noteCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _selectedEmployeeId = e.employeeId;
      _dateFrom = _parseYmd(e.dateFrom);
      _dateTo = _parseYmd(e.dateTo);
      _type = e.type;
      _noteCtrl.text = e.note ?? '';
    } else {
      _selectedEmployeeId = widget.employeeId;
    }
  }

  DateTime? _parseYmd(String s) {
    final parts = s.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  String _typeLabel(String key, AppLocalizations l10n) {
    return switch (key) {
      'absenceTypeVacation' => l10n.absenceTypeVacation,
      'absenceTypeSickLeave' => l10n.absenceTypeSickLeave,
      'absenceTypeUnpaidLeave' => l10n.absenceTypeUnpaidLeave,
      'absenceTypeParentalLeave' => l10n.absenceTypeParentalLeave,
      'absenceTypeStudyLeave' => l10n.absenceTypeStudyLeave,
      'absenceTypeOther' => l10n.absenceTypeOther,
      _ => key,
    };
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final employeeId = _selectedEmployeeId;
    if (employeeId == null) {
      showAppSnack(context, l10n.absenceErrorEmployeeRequired, isError: true);
      return;
    }
    if (_dateFrom == null || _dateTo == null) {
      showAppSnack(context, l10n.absenceErrorDateRequired, isError: true);
      return;
    }
    final dateFrom = dateToYmd(_dateFrom!);
    final dateTo = dateToYmd(_dateTo!);
    if (dateTo.compareTo(dateFrom) < 0) {
      showAppSnack(context, l10n.absenceErrorDateOrder, isError: true);
      return;
    }

    final useCase = ref.read(absencesAdminUseCaseProvider);
    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      if (widget.existing != null) {
        if (!widget.isAdminContext) {
          useCase.validateEmployeeDateRestriction(_type, dateFrom, dateTo);
        }
        await useCase.updateAbsence(
          id: widget.existing!.id,
          dateFrom: dateFrom,
          dateTo: dateTo,
          type: _type,
          note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        );
      } else {
        if (!widget.isAdminContext) {
          useCase.validateEmployeeDateRestriction(_type, dateFrom, dateTo);
        }
        await useCase.insertAbsence(
          employeeId: employeeId,
          dateFrom: dateFrom,
          dateTo: dateTo,
          type: _type,
          note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
          createdByEmployeeId: widget.isAdminContext ? null : employeeId,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
      widget.onSaved?.call();
    } on DomainValidationException catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      final msg = switch (e.message) {
        'absenceErrorOverlap' => l10n.absenceErrorOverlap,
        'absenceErrorDateRestrictionVacation' =>
          l10n.absenceErrorDateRestrictionVacation,
        'absenceErrorDateRestrictionSickLeave' =>
          l10n.absenceErrorDateRestrictionSickLeave,
        'absenceErrorEditPendingOnly' => l10n.absenceErrorEditPendingOnly,
        'absenceErrorDateOrder' => l10n.absenceErrorDateOrder,
        _ => l10n.commonErrorOccurred,
      };
      showAppSnack(context, msg, isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.existing != null;

    return AlertDialog(
      title: Text(isEdit ? l10n.absenceEditTitle : l10n.absenceCreateTitle),
      content: Stack(
        children: [
          SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.isAdminContext) ...[
                    DropdownButtonFormField<int?>(
                      initialValue: _selectedEmployeeId,
                      decoration: InputDecoration(
                        labelText: l10n.absencesEmployee,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        for (final e in widget.employees)
                          DropdownMenuItem(
                            value: e.id,
                            child: Text(
                              EmployeeDisplayName.of(
                                EmployeeDisplay(
                                  firstName: e.firstName,
                                  lastName: e.lastName,
                                ),
                              ),
                            ),
                          ),
                      ],
                      onChanged: (v) => setState(() => _selectedEmployeeId = v),
                    ),
                    const SizedBox(height: 12),
                  ],
                  DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: InputDecoration(
                      labelText: l10n.absencesType,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      for (final t in _absenceTypes)
                        DropdownMenuItem(
                          value: t.$1,
                          child: Text(_typeLabel(t.$2, l10n)),
                        ),
                    ],
                    onChanged: (v) => setState(() => _type = v ?? _type),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final first = widget.isAdminContext
                                ? null
                                : _type == 'sick_leave'
                                ? DateTime.now().subtract(
                                    const Duration(days: 3),
                                  )
                                : DateTime.now();
                            final picked = await _pickDate(
                              context,
                              firstDate: first,
                              initialDate: _dateFrom,
                            );
                            if (picked != null)
                              setState(() => _dateFrom = picked);
                          },
                          child: Text(
                            _dateFrom != null
                                ? dateToYmd(_dateFrom!)
                                : l10n.absencesDateFrom,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final first = _dateFrom ?? DateTime.now();
                            final picked = await _pickDate(
                              context,
                              firstDate: first,
                              initialDate:
                                  _dateTo ?? _dateFrom ?? DateTime.now(),
                            );
                            if (picked != null)
                              setState(() => _dateTo = picked);
                          },
                          child: Text(
                            _dateTo != null
                                ? dateToYmd(_dateTo!)
                                : l10n.absencesDateTo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _noteCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.sessionsTableNote,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          if (_isSaving)
            Positioned.fill(
              child: Container(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.7),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
