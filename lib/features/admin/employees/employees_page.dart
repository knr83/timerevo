import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/usecase_providers.dart';
import '../../../common/utils/employee_display_name.dart';
import '../../../core/error_message_helper.dart';
import '../../../domain/entities/employee_display.dart';
import '../../../domain/entities/employee_details.dart';
import '../../../domain/entities/employee_info.dart';
import '../../../domain/entities/employee_status.dart';
import '../../../domain/entities/schedule_entities.dart';
import '../admin_providers.dart';
import 'employee_card_dialog.dart';

Future<void> _handleSelectEmployee(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  int employeeId,
) async {
  final guard = ref.read(employeeCardGuardProvider);
  if (!guard.isDirty) {
    ref.read(selectedEmployeeIdProvider.notifier).state = employeeId;
    ref.read(isAddingNewProvider.notifier).state = false;
    return;
  }
  final action = await showDialog<_EmployeeListGuardAction>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.employeeUnsavedChangesTitle),
      content: Text(l10n.employeeUnsavedChangesMessage),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(ctx).pop(_EmployeeListGuardAction.cancel),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(ctx).pop(_EmployeeListGuardAction.discard),
          child: Text(l10n.employeeDiscardChanges),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(_EmployeeListGuardAction.save),
          child: Text(l10n.commonSave),
        ),
      ],
    ),
  );
  if (!context.mounted) return;
  switch (action) {
    case _EmployeeListGuardAction.save:
      final ok = await guard.performSave?.call() ?? false;
      if (context.mounted && ok) {
        ref.read(selectedEmployeeIdProvider.notifier).state = employeeId;
        ref.read(isAddingNewProvider.notifier).state = false;
      }
      break;
    case _EmployeeListGuardAction.discard:
      ref.read(selectedEmployeeIdProvider.notifier).state = employeeId;
      ref.read(isAddingNewProvider.notifier).state = false;
      break;
    case _EmployeeListGuardAction.cancel:
    case null:
      break;
  }
}

Future<void> _handleSelectNewEmployee(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) async {
  final guard = ref.read(employeeCardGuardProvider);
  if (!guard.isDirty) {
    ref.read(selectedEmployeeIdProvider.notifier).state = null;
    ref.read(isAddingNewProvider.notifier).state = true;
    return;
  }
  final action = await showDialog<_EmployeeListGuardAction>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.employeeUnsavedChangesTitle),
      content: Text(l10n.employeeUnsavedChangesMessage),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(ctx).pop(_EmployeeListGuardAction.cancel),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(ctx).pop(_EmployeeListGuardAction.discard),
          child: Text(l10n.employeeDiscardChanges),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(_EmployeeListGuardAction.save),
          child: Text(l10n.commonSave),
        ),
      ],
    ),
  );
  if (!context.mounted) return;
  switch (action) {
    case _EmployeeListGuardAction.save:
      final ok = await guard.performSave?.call() ?? false;
      if (context.mounted && ok) {
        ref.read(selectedEmployeeIdProvider.notifier).state = null;
        ref.read(isAddingNewProvider.notifier).state = true;
      }
      break;
    case _EmployeeListGuardAction.discard:
      ref.read(selectedEmployeeIdProvider.notifier).state = null;
      ref.read(isAddingNewProvider.notifier).state = true;
      break;
    case _EmployeeListGuardAction.cancel:
    case null:
      break;
  }
}

class EmployeesPage extends ConsumerWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final employeesAsync = ref.watch(watchAllEmployeesProvider);
    final templatesAsync = ref.watch(watchActiveScheduleTemplatesProvider);
    final selectedId = ref.watch(selectedEmployeeIdProvider);
    final isAddingNew = ref.watch(isAddingNewProvider);

    return employeesAsync.when(
      data: (employees) {
        final templates =
            templatesAsync.value ?? const <ScheduleTemplateInfo>[];
        final effectiveSelectedId = selectedId;
        EmployeeInfo? effectiveSelectedEmployee;
        if (effectiveSelectedId != null) {
          try {
            effectiveSelectedEmployee = employees.firstWhere(
              (e) => e.id == effectiveSelectedId,
            );
          } on StateError {
            // Selected employee was removed from list; treat as no selection.
            effectiveSelectedEmployee = null;
          }
        }
        final showForm = effectiveSelectedEmployee != null || isAddingNew;

        return Row(
          children: [
            SizedBox(
              width: 280,
              child: _EmployeesList(
                employees: employees,
                selectedId: effectiveSelectedId,
                isAddingNew: isAddingNew,
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: showForm
                  ? _EmployeeCardPanel(
                      employee: effectiveSelectedEmployee,
                      isAddingNew: isAddingNew,
                      templates: templates,
                    )
                  : Center(
                      child: Text(
                        employees.isEmpty
                            ? l10n.employeesNoEmployeesYet
                            : l10n.employeesSelectFromList,
                      ),
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          l10n.terminalFailedLoadEmployees(
            errorMessageForUser(e, l10n.commonErrorOccurred),
          ),
        ),
      ),
    );
  }
}

enum _EmployeeListGuardAction { cancel, discard, save }

class _EmployeesList extends ConsumerWidget {
  const _EmployeesList({
    required this.employees,
    required this.selectedId,
    required this.isAddingNew,
  });

  final List<EmployeeInfo> employees;
  final int? selectedId;
  final bool isAddingNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.employeesTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _handleSelectNewEmployee(context, ref, l10n),
                icon: const Icon(Symbols.add),
                tooltip: l10n.commonAdd,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: employees.isEmpty
                ? Text(l10n.employeesNoEmployeesYet)
                : ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final e = employees[index];
                      final isSelected = e.id == selectedId && !isAddingNew;
                      final isInactive = e.status != EmployeeStatus.active;
                      return Opacity(
                        opacity: isInactive ? 0.6 : 1,
                        child: Card(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: ListTile(
                              selected: isSelected,
                              leading: isInactive
                                  ? Icon(
                                      Symbols.person_off,
                                      size: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    )
                                  : null,
                              title: Text(
                                EmployeeDisplayName.of(
                                  EmployeeDisplay(
                                    firstName: e.firstName,
                                    lastName: e.lastName,
                                  ),
                                ),
                                style: isInactive
                                    ? TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      )
                                    : null,
                              ),
                              trailing: isSelected
                                  ? const Icon(Symbols.chevron_right)
                                  : null,
                              onTap: () => _handleSelectEmployee(
                                context,
                                ref,
                                l10n,
                                e.id,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.employeesInactiveHiddenHint,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeCardPanel extends ConsumerStatefulWidget {
  const _EmployeeCardPanel({
    required this.employee,
    required this.isAddingNew,
    required this.templates,
  });

  final EmployeeInfo? employee;
  final bool isAddingNew;
  final List<ScheduleTemplateInfo> templates;

  @override
  ConsumerState<_EmployeeCardPanel> createState() => _EmployeeCardPanelState();
}

class _EmployeeCardPanelState extends ConsumerState<_EmployeeCardPanel> {
  int? _initialTemplateId;
  String? _suggestedCode;
  EmployeeDetails? _loadedDetails;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant _EmployeeCardPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.employee?.id != widget.employee?.id ||
        oldWidget.isAddingNew != widget.isAddingNew) {
      _loaded = false;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final useCase = ref.read(employeesAdminUseCaseProvider);
    if (widget.employee != null) {
      final details = await useCase.getEmployeeDetails(widget.employee!.id);
      if (mounted) {
        setState(() {
          _loadedDetails = details;
          _initialTemplateId = details?.templateId;
          _suggestedCode = details?.code ?? '';
          _loaded = true;
        });
      }
    } else {
      final code = await useCase.getSuggestedEmployeeCode();
      if (mounted) {
        setState(() {
          _loadedDetails = null;
          _initialTemplateId = null;
          _suggestedCode = code;
          _loaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _suggestedCode == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox.expand(
      child: EmployeeCardDialog(
        key: ValueKey(widget.employee?.id ?? 'new'),
        existing: _loadedDetails,
        templates: widget.templates,
        initialTemplateId: _initialTemplateId,
        suggestedCode: _suggestedCode!,
        embedded: true,
        onSaved: (newEmployeeId) {
          ref.read(isAddingNewProvider.notifier).state = false;
          ref.read(selectedEmployeeIdProvider.notifier).state =
              newEmployeeId ?? widget.employee?.id;
        },
      ),
    );
  }
}
