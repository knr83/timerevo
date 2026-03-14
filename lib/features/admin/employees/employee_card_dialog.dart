import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../../app/usecase_providers.dart';
import '../../../common/utils/employee_display_name.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../core/config/data_retention_config.dart';
import '../../../core/employee_pin_status.dart';
import '../../../core/error_message_helper.dart';
import '../../../domain/entities/employee_display.dart';
import '../../../domain/entities/employee_details.dart';
import '../../../domain/entities/employee_status.dart';
import '../../../domain/entities/schedule_entities.dart';
import '../../../ui/legal/legal_doc_page.dart';
import '../admin_providers.dart';

const _employmentTypes = ['full_time', 'part_time', 'minijob', 'custom'];
const _roles = ['employee', 'manager'];

enum _EmployeeGuardAction { cancel, discard, save }

class EmployeeCardDialog extends ConsumerStatefulWidget {
  const EmployeeCardDialog({
    super.key,
    this.existing,
    required this.templates,
    required this.initialTemplateId,
    required this.suggestedCode,
    this.embedded = false,
    this.onSaved,
  });

  final EmployeeDetails? existing;
  final List<ScheduleTemplateInfo> templates;
  final int? initialTemplateId;
  final String suggestedCode;

  /// When true, renders as embedded form (no Dialog). Used in split layout.
  final bool embedded;

  /// Called after successful save when embedded. [newEmployeeId] is set when
  /// creating a new employee. Ignored when in dialog mode.
  final void Function(int? newEmployeeId)? onSaved;

  @override
  ConsumerState<EmployeeCardDialog> createState() => _EmployeeCardDialogState();
}

class _EmployeeCardDialogState extends ConsumerState<EmployeeCardDialog> {
  late final EmployeeCardGuardNotifier _guardNotifier;

  /// Avoid guard update loop: only call setFormState when dirty/save changed.
  bool? _lastGuardDirty;
  Future<bool> Function()? _lastGuardSave;

  late TextEditingController _codeCtrl;
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _accessTokenCtrl;
  late TextEditingController _accessNoteCtrl;
  late TextEditingController _weeklyHoursCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _departmentCtrl;
  late TextEditingController _jobTitleCtrl;
  late TextEditingController _internalCommentCtrl;
  late TextEditingController _secondaryPhoneCtrl;
  late TextEditingController _vacationDaysPerYearCtrl;

  late EmployeeStatus _status;
  late int? _terminationDate;
  late bool _usePin;
  late bool _useNfc;
  late bool _policyAcknowledged;
  late String _employeeRole;
  late String? _employmentType;
  late int? _hireDate;
  late int? _templateId;
  late int? _policyAcknowledgedAt;

  String? _codeError;
  EmployeePinStatus _pinStatus = EmployeePinStatus.notSet;
  int _statusDropdownKey = 0;
  bool _resettingPin = false;

  /// After save in embedded mode, baseline for _isDirty. Null until first save.
  Map<String, dynamic>? _lastSavedValues;

  /// Set when user attempts save; enables showing errorText on empty required fields.
  bool _submitted = false;

  Map<String, dynamic> get _currentValues => {
    'code': _codeCtrl.text.trim().toUpperCase(),
    'firstName': _firstNameCtrl.text.trim(),
    'lastName': _lastNameCtrl.text.trim(),
    'status': _status,
    'usePin': _usePin,
    'useNfc': _useNfc,
    'accessToken': _accessTokenCtrl.text.trim().isEmpty
        ? null
        : _accessTokenCtrl.text.trim(),
    'accessNote': _accessNoteCtrl.text.trim().isEmpty
        ? null
        : _accessNoteCtrl.text.trim(),
    'employmentType': _employmentType,
    'weeklyHours': _weeklyHoursCtrl.text.trim().isEmpty
        ? null
        : double.tryParse(_weeklyHoursCtrl.text.trim()),
    'email': _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
    'phone': _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
    'secondaryPhone': _secondaryPhoneCtrl.text.trim().isEmpty
        ? null
        : _secondaryPhoneCtrl.text.trim(),
    'department': _departmentCtrl.text.trim().isEmpty
        ? null
        : _departmentCtrl.text.trim(),
    'jobTitle': _jobTitleCtrl.text.trim().isEmpty
        ? null
        : _jobTitleCtrl.text.trim(),
    'internalComment': _internalCommentCtrl.text.trim().isEmpty
        ? null
        : _internalCommentCtrl.text.trim(),
    'policyAcknowledged': _policyAcknowledged,
    'policyAcknowledgedAt': _policyAcknowledgedAt,
    'hireDate': _hireDate,
    'terminationDate': _terminationDate,
    'vacationDaysPerYear': _vacationDaysPerYearCtrl.text.trim().isEmpty
        ? null
        : int.tryParse(_vacationDaysPerYearCtrl.text.trim()),
    'employeeRole': _employeeRole,
    'templateId': _templateId,
  };

  Map<String, dynamic> get _initialValues {
    if (_lastSavedValues != null) return _lastSavedValues!;
    final e = widget.existing;
    if (e == null) {
      return {
        'code': widget.suggestedCode,
        'firstName': '',
        'lastName': '',
        'status': EmployeeStatus.active,
        'usePin': false,
        'useNfc': false,
        'accessToken': null,
        'accessNote': null,
        'employmentType': null,
        'weeklyHours': null,
        'email': null,
        'phone': null,
        'secondaryPhone': null,
        'department': null,
        'jobTitle': null,
        'internalComment': null,
        'policyAcknowledged': false,
        'policyAcknowledgedAt': null,
        'hireDate': null,
        'terminationDate': null,
        'vacationDaysPerYear': null,
        'employeeRole': 'employee',
        'templateId': widget.initialTemplateId,
      };
    }
    return {
      'code': e.code,
      'firstName': e.firstName,
      'lastName': e.lastName,
      'status': e.status,
      'usePin': e.usePin,
      'useNfc': e.useNfc,
      'accessToken': e.accessToken,
      'accessNote': e.accessNote,
      'employmentType': e.employmentType,
      'weeklyHours': e.weeklyHours,
      'email': e.email,
      'phone': e.phone,
      'secondaryPhone': e.secondaryPhone,
      'department': e.department,
      'jobTitle': e.jobTitle,
      'internalComment': e.internalComment,
      'policyAcknowledged': e.policyAcknowledged,
      'policyAcknowledgedAt': e.policyAcknowledgedAt,
      'hireDate': e.hireDate,
      'terminationDate': e.terminationDate,
      'vacationDaysPerYear': e.vacationDaysPerYear,
      'employeeRole': e.employeeRole,
      'templateId': widget.initialTemplateId,
    };
  }

  bool _fieldEqual(dynamic c, dynamic i) {
    if (c == i) return true;
    if ((c is String? || c is String) && (i is String? || i is String)) {
      return (c ?? '').toString().trim() == (i ?? '').toString().trim();
    }
    if (c is EmployeeStatus && i is EmployeeStatus) return c == i;
    return false;
  }

  bool get _isDirty {
    final cur = _currentValues;
    final init = _initialValues;
    for (final k in cur.keys) {
      final c = cur[k];
      final i = init[k];
      if (!_fieldEqual(c, i)) return true;
    }
    return false;
  }

  bool get _isValid {
    if (_codeCtrl.text.trim().isEmpty) return false;
    if (_firstNameCtrl.text.trim().isEmpty) return false;
    if (_lastNameCtrl.text.trim().isEmpty) return false;
    if (_templateId == null) return false;
    if (_codeError != null) return false;
    if (_useNfc && _accessTokenCtrl.text.trim().isEmpty) return false;
    final wh = _weeklyHoursCtrl.text.trim();
    if (wh.isNotEmpty) {
      final v = double.tryParse(wh);
      if (v == null || v <= 0) return false;
    }
    final vd = _vacationDaysPerYearCtrl.text.trim();
    if (vd.isNotEmpty) {
      final v = int.tryParse(vd);
      if (v == null || v < 0) return false;
    }
    final em = _emailCtrl.text.trim();
    if (em.isNotEmpty && !em.contains('@')) return false;
    return true;
  }

  @override
  void initState() {
    super.initState();
    _guardNotifier = ref.read(employeeCardGuardProvider.notifier);
    final e = widget.existing;
    _codeCtrl = TextEditingController(text: e?.code ?? widget.suggestedCode);
    _firstNameCtrl = TextEditingController(text: e?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: e?.lastName ?? '');
    _accessTokenCtrl = TextEditingController(text: e?.accessToken ?? '');
    _accessNoteCtrl = TextEditingController(text: e?.accessNote ?? '');
    _weeklyHoursCtrl = TextEditingController(
      text: e?.weeklyHours != null ? e!.weeklyHours.toString() : '',
    );
    _emailCtrl = TextEditingController(text: e?.email ?? '');
    _phoneCtrl = TextEditingController(text: e?.phone ?? '');
    _departmentCtrl = TextEditingController(text: e?.department ?? '');
    _jobTitleCtrl = TextEditingController(text: e?.jobTitle ?? '');
    _internalCommentCtrl = TextEditingController(
      text: e?.internalComment ?? '',
    );
    _secondaryPhoneCtrl = TextEditingController(text: e?.secondaryPhone ?? '');
    _vacationDaysPerYearCtrl = TextEditingController(
      text: e?.vacationDaysPerYear != null
          ? e!.vacationDaysPerYear.toString()
          : '',
    );
    _status = e?.status ?? EmployeeStatus.active;
    _terminationDate = e?.terminationDate;
    _usePin = e?.usePin ?? false;
    _useNfc = e?.useNfc ?? false;
    _policyAcknowledged = e?.policyAcknowledged ?? false;
    _policyAcknowledgedAt = e?.policyAcknowledgedAt;
    _employeeRole = e?.employeeRole ?? 'employee';
    _employmentType = e?.employmentType;
    _hireDate = e?.hireDate;
    _templateId = widget.initialTemplateId;
    if (e != null) {
      _loadPinStatus();
    }
    _codeCtrl.addListener(() => setState(() {}));
    _firstNameCtrl.addListener(() => setState(() {}));
    _lastNameCtrl.addListener(() => setState(() {}));
    _accessTokenCtrl.addListener(() => setState(() {}));
    _accessNoteCtrl.addListener(() => setState(() {}));
    _weeklyHoursCtrl.addListener(() => setState(() {}));
    _emailCtrl.addListener(() => setState(() {}));
    _phoneCtrl.addListener(() => setState(() {}));
    _departmentCtrl.addListener(() => setState(() {}));
    _jobTitleCtrl.addListener(() => setState(() {}));
    _internalCommentCtrl.addListener(() => setState(() {}));
    _secondaryPhoneCtrl.addListener(() => setState(() {}));
    _vacationDaysPerYearCtrl.addListener(() => setState(() {}));
  }

  Future<void> _loadPinStatus() async {
    if (widget.existing == null) return;
    final status = await ref
        .read(employeesAdminUseCaseProvider)
        .getPinStatus(widget.existing!.id);
    if (mounted) setState(() => _pinStatus = status);
  }

  @override
  void dispose() {
    if (widget.embedded) {
      _guardNotifier.clear();
    }
    _codeCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _accessTokenCtrl.dispose();
    _accessNoteCtrl.dispose();
    _weeklyHoursCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _departmentCtrl.dispose();
    _jobTitleCtrl.dispose();
    _internalCommentCtrl.dispose();
    _secondaryPhoneCtrl.dispose();
    _vacationDaysPerYearCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkCodeUnique() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    final unique = await ref
        .read(employeesAdminUseCaseProvider)
        .checkCodeUnique(code, excludeEmployeeId: widget.existing?.id);
    if (mounted) {
      final loc = AppLocalizations.of(context);
      setState(
        () => _codeError = unique ? null : loc.employeeCodeAlreadyExists,
      );
    }
  }

  String _employmentTypeLabel(String? v) {
    final l10n = AppLocalizations.of(context);
    if (v == null) return l10n.commonNone;
    return switch (v) {
      'full_time' => l10n.employeeEmploymentTypeFullTime,
      'part_time' => l10n.employeeEmploymentTypePartTime,
      'minijob' => l10n.employeeEmploymentTypeMinijob,
      'custom' => l10n.employeeEmploymentTypeCustom,
      _ => v,
    };
  }

  String _roleLabel(String v) => switch (v) {
    'manager' => AppLocalizations.of(context).employeeRoleManager,
    _ => AppLocalizations.of(context).employeeRoleEmployee,
  };

  Future<void> _pickHireDate() async {
    final now = DateTime.now();
    final initial = _hireDate != null
        ? DateTime.fromMillisecondsSinceEpoch(_hireDate!, isUtc: true)
        : now;
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 50),
      lastDate: now,
      initialDate: initial,
    );
    if (date != null && mounted) {
      setState(
        () => _hireDate = DateTime.utc(
          date.year,
          date.month,
          date.day,
        ).millisecondsSinceEpoch,
      );
    }
  }

  Future<void> _pickTerminationDate() async {
    final now = DateTime.now();
    final initial = _terminationDate != null
        ? DateTime.fromMillisecondsSinceEpoch(_terminationDate!, isUtc: true)
        : now;
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 50),
      lastDate: DateTime(now.year + 10),
      initialDate: initial,
    );
    if (date != null && mounted) {
      setState(
        () => _terminationDate = DateTime.utc(
          date.year,
          date.month,
          date.day,
        ).millisecondsSinceEpoch,
      );
    }
  }

  Future<void> _onStatusChanged(EmployeeStatus newStatus) async {
    if (newStatus == _status) return;
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.employeeStatusChangeConfirmTitle),
        content: Text(l10n.employeeStatusChangeConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.employeeStatusChangeConfirmConfirm),
          ),
        ],
      ),
    );
    if (mounted) {
      if (confirmed == true) {
        setState(() {
          _status = newStatus;
          _statusDropdownKey++;
        });
      } else {
        setState(() => _statusDropdownKey++);
      }
    }
  }

  Future<bool> _save() async {
    if (!_isValid || !_isDirty) {
      if (!_submitted) setState(() => _submitted = true);
      return false;
    }
    final l10n = AppLocalizations.of(context);
    final useCase = ref.read(employeesAdminUseCaseProvider);
    try {
      int? newEmployeeId;
      if (widget.existing == null) {
        newEmployeeId = await useCase.createEmployeeFull(
          code: _codeCtrl.text.trim().toUpperCase(),
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          status: _status,
          hireDate: _hireDate,
          terminationDate: _terminationDate,
          vacationDaysPerYear: _vacationDaysPerYearCtrl.text.trim().isEmpty
              ? null
              : int.tryParse(_vacationDaysPerYearCtrl.text.trim()),
          employeeRole: _employeeRole,
          usePin: _usePin,
          useNfc: _useNfc,
          accessToken: _accessTokenCtrl.text.trim().isEmpty
              ? null
              : _accessTokenCtrl.text.trim(),
          accessNote: _accessNoteCtrl.text.trim().isEmpty
              ? null
              : _accessNoteCtrl.text.trim(),
          employmentType: _employmentType,
          weeklyHours: _weeklyHoursCtrl.text.trim().isEmpty
              ? null
              : double.tryParse(_weeklyHoursCtrl.text.trim()),
          email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
          department: _departmentCtrl.text.trim().isEmpty
              ? null
              : _departmentCtrl.text.trim(),
          jobTitle: _jobTitleCtrl.text.trim().isEmpty
              ? null
              : _jobTitleCtrl.text.trim(),
          internalComment: _internalCommentCtrl.text.trim().isEmpty
              ? null
              : _internalCommentCtrl.text.trim(),
          policyAcknowledged: _policyAcknowledged,
          policyAcknowledgedAt: _policyAcknowledgedAt,
          templateId: _templateId,
        );
      } else {
        await useCase.updateEmployeeFull(
          id: widget.existing!.id,
          code: _codeCtrl.text.trim().toUpperCase(),
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          status: _status,
          hireDate: _hireDate,
          terminationDate: _terminationDate,
          vacationDaysPerYear: _vacationDaysPerYearCtrl.text.trim().isEmpty
              ? null
              : int.tryParse(_vacationDaysPerYearCtrl.text.trim()),
          employeeRole: _employeeRole,
          usePin: _usePin,
          useNfc: _useNfc,
          accessToken: _accessTokenCtrl.text.trim().isEmpty
              ? null
              : _accessTokenCtrl.text.trim(),
          accessNote: _accessNoteCtrl.text.trim().isEmpty
              ? null
              : _accessNoteCtrl.text.trim(),
          employmentType: _employmentType,
          weeklyHours: _weeklyHoursCtrl.text.trim().isEmpty
              ? null
              : double.tryParse(_weeklyHoursCtrl.text.trim()),
          email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
          secondaryPhone: _secondaryPhoneCtrl.text.trim().isEmpty
              ? null
              : _secondaryPhoneCtrl.text.trim(),
          department: _departmentCtrl.text.trim().isEmpty
              ? null
              : _departmentCtrl.text.trim(),
          jobTitle: _jobTitleCtrl.text.trim().isEmpty
              ? null
              : _jobTitleCtrl.text.trim(),
          internalComment: _internalCommentCtrl.text.trim().isEmpty
              ? null
              : _internalCommentCtrl.text.trim(),
          policyAcknowledged: _policyAcknowledged,
          policyAcknowledgedAt: _policyAcknowledgedAt,
          templateId: _templateId,
        );
      }
      if (mounted) {
        if (widget.embedded) {
          _lastSavedValues = Map<String, dynamic>.from(_currentValues);
          widget.onSaved?.call(newEmployeeId);
          setState(() {});
        } else {
          Navigator.of(context).pop(true);
        }
      }
    } catch (err) {
      if (mounted) {
        showAppSnack(
          context,
          widget.existing == null
              ? l10n.employeeCreateFailed(
                  errorMessageForUser(err, l10n.commonErrorOccurred),
                )
              : l10n.employeeUpdateFailed(
                  errorMessageForUser(err, l10n.commonErrorOccurred),
                ),
          isError: true,
        );
      }
      return false;
    }
    return true;
  }

  Future<void> _handleCloseAttempt() async {
    if (!_isDirty) {
      if (mounted) Navigator.of(context).pop(false);
      return;
    }
    final l10n = AppLocalizations.of(context);
    final action = await showDialog<_EmployeeGuardAction>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.employeeUnsavedChangesTitle),
        content: Text(l10n.employeeUnsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(_EmployeeGuardAction.cancel),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(_EmployeeGuardAction.discard),
            child: Text(l10n.employeeDiscardChanges),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(_EmployeeGuardAction.save),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    if (!mounted) return;
    switch (action) {
      case _EmployeeGuardAction.save:
        await _save();
        break;
      case _EmployeeGuardAction.discard:
        Navigator.of(context).pop(false);
        break;
      case _EmployeeGuardAction.cancel:
      case null:
        break;
    }
  }

  String _appBarTitle(AppLocalizations l10n) {
    if (widget.existing == null) return l10n.employeeDialogNewTitle;
    final first = _firstNameCtrl.text.trim();
    final last = _lastNameCtrl.text.trim();
    if (first.isEmpty && last.isEmpty) return l10n.employeeDialogEditTitle;
    return EmployeeDisplayName.of(
      EmployeeDisplay(firstName: first, lastName: last),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      final dirty = _isDirty;
      final save = _save;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_lastGuardDirty != dirty || _lastGuardSave != save) {
          _lastGuardDirty = dirty;
          _lastGuardSave = save;
          _guardNotifier.setFormState(dirty, save);
        }
      });
    }
    final l10n = AppLocalizations.of(context);
    final content = _buildFormContent(l10n);

    if (widget.embedded) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400),
        child: content,
      );
    }
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 780),
        child: content,
      ),
    );
  }


  Widget _buildFormContent(AppLocalizations l10n) {
    return Column(
      mainAxisSize: widget.embedded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        AppBar(
          title: Text(_appBarTitle(l10n)),
          leading: widget.embedded
              ? null
              : IconButton(
                  icon: const Icon(Symbols.close),
                  tooltip: l10n.commonClose,
                  onPressed: _handleCloseAttempt,
                ),
          automaticallyImplyLeading: !widget.embedded,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: FilledButton(
                onPressed: (_isValid && _isDirty) ? _save : null,
                child: Text(l10n.commonSave),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildGeneralTabContent(l10n),
                const SizedBox(height: 12),
                _buildContactTabContent(l10n),
                const SizedBox(height: 12),
                _buildTerminalAccessTabContent(l10n),
                const SizedBox(height: 12),
                _buildAdditionalTabContent(l10n),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralTabContent(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SectionCard(
                  title: l10n.employeeSectionBasicInfo,
                  icon: Symbols.badge,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.commonRequiredFieldsLegend,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _firstNameCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.employeeFieldLabelWithRequired(
                                  l10n.employeeFirstName,
                                ),
                                errorText:
                                    _submitted &&
                                        _firstNameCtrl.text.trim().isEmpty
                                    ? l10n.employeeFirstNameRequired
                                    : null,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _lastNameCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.employeeFieldLabelWithRequired(
                                  l10n.employeeLastName,
                                ),
                                errorText:
                                    _submitted &&
                                        _lastNameCtrl.text.trim().isEmpty
                                    ? l10n.employeeLastNameRequired
                                    : null,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: _codeCtrl,
                                  readOnly: widget.existing != null,
                                  decoration: InputDecoration(
                                    labelText: l10n.employeeCode,
                                    hintText: l10n.employeeCodeHint,
                                    errorText:
                                        _codeError ??
                                        (_submitted &&
                                                widget.existing == null &&
                                                _codeCtrl.text.trim().isEmpty
                                            ? l10n.employeeCodeRequired
                                            : null),
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  onChanged: widget.existing == null
                                      ? (_) => setState(() {
                                            _codeError = null;
                                          })
                                      : null,
                                  onEditingComplete: widget.existing == null
                                      ? _checkCodeUnique
                                      : null,
                                  onTapOutside: widget.existing == null
                                      ? (_) => _checkCodeUnique()
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<EmployeeStatus>(
                                  key: ValueKey('status_$_statusDropdownKey'),
                                  initialValue: _status,
                                  decoration: InputDecoration(
                                    labelText: l10n.employeeStatusLabel,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: EmployeeStatus.active,
                                      child: Text(l10n.employeeStatusActive),
                                    ),
                                    DropdownMenuItem(
                                      value: EmployeeStatus.inactive,
                                      child: Text(l10n.employeeStatusInactive),
                                    ),
                                    DropdownMenuItem(
                                      value: EmployeeStatus.archived,
                                      child: Text(l10n.employeeStatusArchived),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) _onStatusChanged(v);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: l10n.employeeSectionEmployment,
                  icon: Symbols.work,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _employeeRole,
                              decoration: InputDecoration(
                                labelText: l10n.employeeRole,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              items: _roles
                                  .map(
                                    (r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(_roleLabel(r)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(
                                () => _employeeRole = v ?? 'employee',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String?>(
                              initialValue: _employmentType,
                              decoration: InputDecoration(
                                labelText: l10n.employeeEmploymentType,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              items: [
                                DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text(l10n.commonNone),
                                ),
                                ..._employmentTypes.map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(_employmentTypeLabel(t)),
                                  ),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _employmentType = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: l10n.employeeHireDate,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: InkWell(
                                  onTap: _pickHireDate,
                                  child: Padding(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      _hireDate != null
                                          ? DateFormat.yMd().format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                _hireDate!,
                                                isUtc: true,
                                              ),
                                            )
                                          : l10n.commonNone,
                                      style: TextStyle(
                                        color: _hireDate != null
                                            ? null
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: l10n.employeeTerminationDateLabel,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: InkWell(
                                  onTap: _pickTerminationDate,
                                  child: Padding(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      _terminationDate != null
                                          ? DateFormat.yMd().format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                _terminationDate!,
                                                isUtc: true,
                                              ),
                                            )
                                          : l10n.commonNone,
                                      style: TextStyle(
                                        color: _terminationDate != null
                                            ? null
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _weeklyHoursCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.employeeWeeklyHours,
                                border: const OutlineInputBorder(),
                                hintText: l10n.employeeWeeklyHoursHint,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _vacationDaysPerYearCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText:
                                    l10n.employeeVacationDaysPerYearLabel,
                                border: const OutlineInputBorder(),
                                hintText: l10n.commonNone,
                                errorText:
                                    _submitted &&
                                            _vacationDaysPerYearCtrl
                                                .text
                                                .trim()
                                                .isNotEmpty &&
                                            (int.tryParse(
                                                        _vacationDaysPerYearCtrl
                                                            .text
                                                            .trim()) ==
                                                    null ||
                                                int.parse(
                                                        _vacationDaysPerYearCtrl
                                                            .text
                                                            .trim()) <
                                                    0)
                                    ? l10n.employeeVacationDaysPerYearInvalid
                                    : null,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _departmentCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.employeeDepartment,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _jobTitleCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.employeeJobTitle,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: l10n.employeeSectionSchedule,
                  icon: Symbols.schedule,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<int?>(
                        initialValue: _templateId,
                        decoration: InputDecoration(
                          labelText: l10n.employeeFieldLabelWithRequired(
                            l10n.employeeSectionSchedule,
                          ),
                          border: const OutlineInputBorder(),
                          errorText: _submitted && _templateId == null
                              ? l10n.employeeScheduleRequired
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.commonNone),
                          ),
                          ...widget.templates.map(
                            (t) => DropdownMenuItem<int>(
                              value: t.id,
                              child: Text(t.name),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => _templateId = v),
                      ),
                    ],
                  ),
                ),
              ],
    );
  }

  Widget _buildContactTabContent(AppLocalizations l10n) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SectionCard(
            title: l10n.employeeSectionContact,
            icon: Symbols.contact_phone,
            child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _emailCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: l10n.employeeEmail,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _phoneCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: l10n.employeePhone,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _secondaryPhoneCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: l10n.employeeSecondaryPhoneLabel,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
    );
  }

  Widget _buildTerminalAccessTabContent(AppLocalizations l10n) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SectionCard(
            title: l10n.employeeSectionAccess,
            icon: Symbols.key,
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          _CompactSwitch(
                            value: _usePin,
                            onChanged: (v) => setState(() => _usePin = v),
                            label: l10n.employeeUsePin,
                          ),
                          const Spacer(),
                          if (_usePin)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.employeePinStatusWithValue(
                                    _pinStatus == EmployeePinStatus.set
                                        ? l10n.employeePinStatusSet
                                        : l10n.employeePinStatusNotSet,
                                  ),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                if (widget.existing != null) ...[
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: _showSetPinDialog,
                                    child: Text(l10n.employeeSetPin),
                                  ),
                                  TextButton(
                                    onPressed: _resettingPin ? null : _resetPin,
                                    child: _resettingPin
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(l10n.employeeResetPin),
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                      _CompactSwitch(
                        value: _useNfc,
                        onChanged: (v) => setState(() => _useNfc = v),
                        label: l10n.employeeUseNfc,
                      ),
                      if (!_usePin && !_useNfc)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          child: Text(
                            l10n.employeeTerminalAccessDisabled,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _accessTokenCtrl,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: _useNfc
                              ? l10n.employeeFieldLabelWithRequired(
                                  l10n.employeeAccessToken,
                                )
                              : l10n.employeeAccessToken,
                          border: const OutlineInputBorder(),
                          errorText:
                              _submitted &&
                                  _useNfc &&
                                  _accessTokenCtrl.text.trim().isEmpty
                              ? l10n.employeeAccessTokenRequiredWhenNfc
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _accessNoteCtrl,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: l10n.employeeAccessNote,
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
    );
  }

  Widget _buildAdditionalTabContent(AppLocalizations l10n) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SectionCard(
            title: l10n.employeeSectionPolicy,
            icon: Symbols.policy,
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _internalCommentCtrl,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: l10n.employeeInternalComment,
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        value: _policyAcknowledged,
                        onChanged: null,
                        title: _PolicyLinksText(
                          l10n: l10n,
                          baseStyle:
                              Theme.of(context).textTheme.bodyMedium ??
                              const TextStyle(),
                          linkStyle:
                              (Theme.of(context).textTheme.bodyMedium ??
                                      const TextStyle())
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (_policyAcknowledgedAt != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            l10n.employeePolicyAcknowledgedAtWithValue(
                              DateFormat.yMd().add_Hm().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  _policyAcknowledgedAt!,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      Text(
                        dataRetentionPolicyText,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
          if (widget.existing != null) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: l10n.employeeSectionAudit,
              icon: Symbols.history,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.employeeCreatedAtWithValue(
                      DateFormat.yMd().add_Hm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                          widget.existing!.createdAt,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  if (widget.existing!.updatedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.employeeUpdatedAtWithValue(
                        DateFormat.yMd().add_Hm().format(
                          DateTime.fromMillisecondsSinceEpoch(
                            widget.existing!.updatedAt!,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
    );
  }

  Future<void> _showSetPinDialog() async {
    if (widget.existing == null) return;
    final success = await showDialog<bool>(
      context: context,
      builder: (ctx) => _SetPinDialogContent(
        setEmployeePin: (pin) => ref
            .read(employeesAdminUseCaseProvider)
            .setEmployeePin(employeeId: widget.existing!.id, pin: pin),
      ),
    );
    if (success == true && mounted) _loadPinStatus();
  }

  Future<void> _resetPin() async {
    if (widget.existing == null || _resettingPin) return;
    setState(() => _resettingPin = true);
    try {
      await ref
          .read(employeesAdminUseCaseProvider)
          .resetEmployeePin(widget.existing!.id);
      if (mounted) {
        setState(() {
          _pinStatus = EmployeePinStatus.notSet;
          _resettingPin = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showAppSnack(
          context,
          AppLocalizations.of(context).commonErrorOccurred,
          isError: true,
        );
        setState(() => _resettingPin = false);
      }
    }
  }
}

class _SetPinDialogContent extends StatefulWidget {
  const _SetPinDialogContent({required this.setEmployeePin});

  final Future<void> Function(String pin) setEmployeePin;

  @override
  State<_SetPinDialogContent> createState() => _SetPinDialogContentState();
}

class _SetPinDialogContentState extends State<_SetPinDialogContent> {
  late final TextEditingController _ctrl;
  bool _saving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _ctrl.text.trim();
    if (pin.isEmpty || _saving) return;
    setState(() {
      _saving = true;
      _errorText = null;
    });
    try {
      await widget.setEmployeePin(pin);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      final msg = AppLocalizations.of(context).commonErrorOccurred;
      setState(() {
        _saving = false;
        _errorText = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.employeeSetPin),
      content: TextField(
        controller: _ctrl,
        obscureText: true,
        enabled: !_saving,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: l10n.adminPinLabel,
          border: const OutlineInputBorder(),
          errorText: _errorText,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, null),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.commonSave),
        ),
      ],
    );
  }
}

/// Compact switch with label next to the toggle, not stretched across full width.
class _CompactSwitch extends StatelessWidget {
  const _CompactSwitch({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  static const double _defaultScale = 0.8;

  @override
  Widget build(BuildContext context) {
    final switchWidget = Switch(value: value, onChanged: onChanged);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(width: 12),
        Transform.scale(scale: _defaultScale, child: switchWidget),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _PolicyLinksText extends StatelessWidget {
  const _PolicyLinksText({
    required this.l10n,
    required this.baseStyle,
    required this.linkStyle,
  });

  final AppLocalizations l10n;
  final TextStyle baseStyle;
  final TextStyle linkStyle;

  void _openPrivacy(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LegalDocPage(
          title: l10n.settingsPrivacyPolicy,
          assetPath: LegalDocPage.privacyPath,
        ),
      ),
    );
  }

  void _openTerms(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LegalDocPage(
          title: l10n.legalTerms,
          assetPath: LegalDocPage.termsPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: l10n.employeePolicyPrefix),
          TextSpan(
            text: l10n.employeePolicyLinkPrivacy,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openPrivacy(context),
          ),
          TextSpan(text: l10n.employeePolicyMiddle),
          TextSpan(
            text: l10n.employeePolicyLinkTerms,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openTerms(context),
          ),
        ],
      ),
    );
  }
}
