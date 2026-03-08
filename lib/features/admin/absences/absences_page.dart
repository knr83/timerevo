import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../../app/absences_providers.dart';
import '../../../app/usecase_providers.dart';
import '../../../common/utils/employee_display_name.dart';
import '../../../common/widgets/app_snack.dart';
import '../../../common/widgets/date_time_filter_chip.dart';
import '../../../core/domain_errors.dart';
import '../../../domain/entities/absence_info.dart';
import '../../../domain/entities/absence_with_employee_info.dart';
import '../../../domain/entities/employee_display.dart';
import '../../../domain/entities/employee_info.dart';
import 'absence_request_dialog.dart';

String _utcMsToYmd(int ms) {
  final d = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

String _typeLabel(String type, AppLocalizations l10n) {
  return switch (type) {
    'vacation' => l10n.absenceTypeVacation,
    'sick_leave' => l10n.absenceTypeSickLeave,
    'unpaid_leave' => l10n.absenceTypeUnpaidLeave,
    'parental_leave' => l10n.absenceTypeParentalLeave,
    'study_leave' => l10n.absenceTypeStudyLeave,
    'other' => l10n.absenceTypeOther,
    _ => type,
  };
}

String _statusLabel(String status, AppLocalizations l10n) {
  return switch (status) {
    'PENDING' => l10n.absenceStatusPending,
    'APPROVED' => l10n.absenceStatusApproved,
    'REJECTED' => l10n.absenceStatusRejected,
    _ => status,
  };
}

Widget _statusChip(String status, AppLocalizations l10n, BuildContext context) {
  final color = switch (status) {
    'PENDING' => Theme.of(context).colorScheme.tertiary,
    'APPROVED' => Theme.of(context).colorScheme.primary,
    'REJECTED' => Theme.of(context).colorScheme.error,
    _ => Theme.of(context).colorScheme.surfaceContainerHighest,
  };
  return Chip(
    label: Text(_statusLabel(status, l10n)),
    backgroundColor: color.withValues(alpha: 0.3),
    side: BorderSide(color: color),
    padding: EdgeInsets.zero,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

String _resolveAbsenceError(String key, AppLocalizations l10n) {
  return switch (key) {
    'absenceErrorDeletePendingOnly' => l10n.absenceErrorDeletePendingOnly,
    'absenceErrorEditPendingOnly' => l10n.absenceErrorEditPendingOnly,
    'absenceErrorApproveRejectPendingOnly' =>
      l10n.absenceErrorApproveRejectPendingOnly,
    'absenceErrorRejectReasonRequired' => l10n.absenceErrorRejectReasonRequired,
    'absenceErrorDateOrder' => l10n.absenceErrorDateOrder,
    _ => key,
  };
}

final _absencesFiltersProvider =
    StateProvider<_AbsencesFilters>((ref) => _AbsencesFilters.initial());

final _employeesAllProvider = watchAllEmployeesProvider;

final _absencesProvider =
    StreamProvider<List<AbsenceWithEmployeeInfo>>((ref) {
  final filters = ref.watch(_absencesFiltersProvider);
  String? fromDate;
  String? toDate;
  if (filters.fromUtcMs != null) {
    fromDate = _utcMsToYmd(filters.fromUtcMs!);
  }
  if (filters.toUtcMs != null) {
    toDate = _utcMsToYmd(filters.toUtcMs!);
  }
  return ref.watch(watchAbsencesUseCaseProvider).streamAbsences(
        employeeId: filters.employeeId,
        fromDate: fromDate,
        toDate: toDate,
        status: filters.status,
      );
});

class _AbsencesFilters {
  const _AbsencesFilters({
    required this.employeeId,
    required this.fromUtcMs,
    required this.toUtcMs,
    required this.status,
  });

  final int? employeeId;
  final int? fromUtcMs;
  final int? toUtcMs;
  final String? status;

  factory _AbsencesFilters.initial() => const _AbsencesFilters(
        employeeId: null,
        fromUtcMs: null,
        toUtcMs: null,
        status: null,
      );

  _AbsencesFilters copyWith({
    Object? employeeId = _sentinel,
    Object? fromUtcMs = _sentinel,
    Object? toUtcMs = _sentinel,
    Object? status = _sentinel,
  }) {
    return _AbsencesFilters(
      employeeId:
          identical(employeeId, _sentinel) ? this.employeeId : employeeId as int?,
      fromUtcMs:
          identical(fromUtcMs, _sentinel) ? this.fromUtcMs : fromUtcMs as int?,
      toUtcMs: identical(toUtcMs, _sentinel) ? this.toUtcMs : toUtcMs as int?,
      status: identical(status, _sentinel) ? this.status : status as String?,
    );
  }
}

const _sentinel = Object();

const _sortColumnEmployee = 0;
const _sortColumnType = 1;
const _sortColumnDateFrom = 2;
const _sortColumnDateTo = 3;
const _sortColumnStatus = 4;

final _absencesSortProvider = StateProvider<({int? columnIndex, bool ascending})>(
  (ref) => (columnIndex: _sortColumnDateFrom, ascending: false),
);

List<AbsenceWithEmployeeInfo> _sortAbsences(
  List<AbsenceWithEmployeeInfo> rows,
  int? columnIndex,
  bool ascending,
  AppLocalizations l10n,
  String Function(EmployeeInfo) employeeName,
) {
  if (columnIndex == null) return rows;
  final list = List<AbsenceWithEmployeeInfo>.from(rows);
  list.sort((a, b) {
    int cmp;
    switch (columnIndex) {
      case _sortColumnEmployee:
        cmp = employeeName(a.employee).compareTo(employeeName(b.employee));
        break;
      case _sortColumnType:
        cmp = _typeLabel(a.absence.type, l10n).compareTo(_typeLabel(b.absence.type, l10n));
        break;
      case _sortColumnDateFrom:
        cmp = a.absence.dateFrom.compareTo(b.absence.dateFrom);
        break;
      case _sortColumnDateTo:
        cmp = a.absence.dateTo.compareTo(b.absence.dateTo);
        break;
      case _sortColumnStatus:
        cmp = _statusLabel(a.absence.status, l10n).compareTo(_statusLabel(b.absence.status, l10n));
        break;
      default:
        cmp = 0;
    }
    return ascending ? cmp : -cmp;
  });
  return list;
}

class AbsencesPage extends ConsumerWidget {
  const AbsencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final employeesAsync = ref.watch(_employeesAllProvider);
    final absencesAsync = ref.watch(_absencesProvider);
    final filters = ref.watch(_absencesFiltersProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.absencesTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _openAddDialog(context, ref, l10n, employeesAsync),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.absencesAdd),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                employeesAsync.when(
                  data: (employees) {
                    return DropdownMenu<int?>(
                      key: ValueKey('employee_${filters.employeeId}'),
                      label: Text(l10n.absencesEmployee),
                      initialSelection: filters.employeeId,
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: null, label: l10n.sessionsEmployeeAll),
                        ...employees.map(
                          (e) => DropdownMenuEntry(
                            value: e.id,
                            label: EmployeeDisplayName.of(EmployeeDisplay(
                            firstName: e.firstName, lastName: e.lastName)),
                          ),
                        ),
                      ],
                      onSelected: (v) => ref
                          .read(_absencesFiltersProvider.notifier)
                          .state = filters.copyWith(employeeId: v),
                    );
                  },
                  loading: () => const SizedBox(width: 180, height: 56),
                  error: (e, _) => Text(l10n.commonErrorOccurred),
                ),
                DropdownMenu<String?>(
                  key: ValueKey('status_${filters.status}'),
                  label: Text(l10n.absencesStatus),
                  initialSelection: filters.status,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: null, label: l10n.sessionsEmployeeAll),
                    DropdownMenuEntry(value: 'PENDING', label: l10n.absenceStatusPending),
                    DropdownMenuEntry(value: 'APPROVED', label: l10n.absenceStatusApproved),
                    DropdownMenuEntry(value: 'REJECTED', label: l10n.absenceStatusRejected),
                  ],
                  onSelected: (v) => ref
                      .read(_absencesFiltersProvider.notifier)
                      .state = filters.copyWith(status: v),
                ),
                DateTimeFilterChip(
                  label: l10n.sessionsFilterFrom,
                  valueUtcMs: filters.fromUtcMs,
                  onPickedUtcMs: (v) => ref
                      .read(_absencesFiltersProvider.notifier)
                      .state = filters.copyWith(fromUtcMs: v),
                  onCleared: () => ref
                      .read(_absencesFiltersProvider.notifier)
                      .state = filters.copyWith(fromUtcMs: null),
                ),
                DateTimeFilterChip(
                  label: l10n.sessionsFilterTo,
                  valueUtcMs: filters.toUtcMs,
                  onPickedUtcMs: (v) => ref
                      .read(_absencesFiltersProvider.notifier)
                      .state = filters.copyWith(toUtcMs: v),
                  onCleared: () => ref
                      .read(_absencesFiltersProvider.notifier)
                      .state = filters.copyWith(toUtcMs: null),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: absencesAsync.when(
                data: (rows) {
                  if (rows.isEmpty) {
                    return Center(child: Text(l10n.absencesEmpty));
                  }
                  final sort = ref.watch(_absencesSortProvider);
                  final employees = employeesAsync.valueOrNull ?? [];
                  final sortedRows = _sortAbsences(
                    rows,
                    sort.columnIndex,
                    sort.ascending,
                    l10n,
                    (e) => EmployeeDisplayName.of(EmployeeDisplay(
                      firstName: e.firstName, lastName: e.lastName)),
                  );
                  return _AbsencesTable(
                    rows: sortedRows,
                    employees: employees,
                    sortColumnIndex: sort.columnIndex,
                    sortAscending: sort.ascending,
                    onSort: (columnIndex, ascending) {
                      ref.read(_absencesSortProvider.notifier).state =
                          (columnIndex: columnIndex, ascending: ascending);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(l10n.commonErrorOccurred)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AsyncValue<List<EmployeeInfo>> employeesAsync,
  ) async {
    final employees = employeesAsync.valueOrNull ?? [];
    if (employees.isEmpty) {
      showAppSnack(context, l10n.sessionsNoEmployeesAvailable, isError: true);
      return;
    }

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AbsenceRequestDialog(
        isAdminContext: true,
        employees: employees,
        onSaved: () {},
      ),
    );
    if (saved == true && context.mounted) {
      showAppSnack(context, l10n.absenceCreated);
    }
  }
}

class _AbsencesTable extends ConsumerWidget {
  const _AbsencesTable({
    required this.rows,
    required this.employees,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
  });

  final List<AbsenceWithEmployeeInfo> rows;
  final List<EmployeeInfo> employees;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int columnIndex, bool ascending)? onSort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: sortColumnIndex,
        sortAscending: sortAscending,
        columns: [
          DataColumn(
            label: Text(l10n.absencesEmployee),
            onSort: onSort != null ? (_, ascending) => onSort!(_sortColumnEmployee, ascending) : null,
          ),
          DataColumn(
            label: Text(l10n.absencesType),
            onSort: onSort != null ? (_, ascending) => onSort!(_sortColumnType, ascending) : null,
          ),
          DataColumn(
            label: Text(l10n.absencesDateFrom),
            onSort: onSort != null ? (_, ascending) => onSort!(_sortColumnDateFrom, ascending) : null,
          ),
          DataColumn(
            label: Text(l10n.absencesDateTo),
            onSort: onSort != null ? (_, ascending) => onSort!(_sortColumnDateTo, ascending) : null,
          ),
          DataColumn(
            label: Text(l10n.absencesStatus),
            onSort: onSort != null ? (_, ascending) => onSort!(_sortColumnStatus, ascending) : null,
          ),
          DataColumn(label: Text(l10n.absencesApprovedBy)),
          DataColumn(label: Text(l10n.absencesApprovedAt)),
          DataColumn(label: Text(l10n.absencesActions)),
        ],
        rows: rows.map((row) {
          final a = row.absence;
          final e = row.employee;
          final isPending = a.status == 'PENDING';

          final approvedByText = a.status != 'PENDING' ? (a.approvedBy ?? l10n.commonNotAvailable) : l10n.commonNotAvailable;
          final approvedAtText = a.approvedAt != null
              ? _utcMsToYmd(a.approvedAt!)
              : l10n.commonNotAvailable;

          return DataRow(
            cells: [
              DataCell(Text(EmployeeDisplayName.of(EmployeeDisplay(
                    firstName: e.firstName, lastName: e.lastName)))),
              DataCell(Text(_typeLabel(a.type, l10n))),
              DataCell(Text(a.dateFrom)),
              DataCell(Text(a.dateTo)),
              DataCell(_statusChip(a.status, l10n, context)),
              DataCell(Text(approvedByText)),
              DataCell(Text(approvedAtText)),
              DataCell(
                isPending
                    ? PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _edit(context, ref, a);
                              break;
                            case 'delete':
                              _delete(context, ref, a.id, l10n);
                              break;
                            case 'approve':
                              _approve(context, ref, a.id, l10n);
                              break;
                            case 'reject':
                              _reject(context, ref, a.id, l10n);
                              break;
                          }
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(l10n.absenceEdit),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(l10n.absenceDelete),
                          ),
                          PopupMenuItem(
                            value: 'approve',
                            child: Text(l10n.absenceApprove),
                          ),
                          PopupMenuItem(
                            value: 'reject',
                            child: Text(l10n.absenceReject),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        }).toList(growable: false),
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, AbsenceInfo a) async {
    final employees = this.employees;
    final match = employees.where((e) => e.id == a.employeeId).toList();
    if (match.isEmpty) return;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AbsenceRequestDialog(
        existing: a,
        isAdminContext: true,
        employees: employees,
        onSaved: () {},
      ),
    );
    if (saved == true && context.mounted) {
      showAppSnack(context, AppLocalizations.of(context).absenceUpdated);
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    int id,
    AppLocalizations l10n,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.absenceDelete),
        content: Text(l10n.absenceDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonRemove),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    try {
      await ref.read(absencesAdminUseCaseProvider).deleteAbsence(id);
      if (context.mounted) {
        showAppSnack(context, l10n.absenceDeleted);
      }
    } on DomainException catch (e) {
      if (context.mounted) {
        showAppSnack(context, _resolveAbsenceError(e.message, l10n), isError: true);
      }
    }
  }

  Future<void> _approve(
    BuildContext context,
    WidgetRef ref,
    int id,
    AppLocalizations l10n,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.absenceApprove),
        content: Text(l10n.absenceApproveConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    try {
      await ref.read(absencesAdminUseCaseProvider).updateAbsenceStatus(
            id: id,
            status: 'APPROVED',
            approvedBy: 'admin',
          );
      if (context.mounted) {
        showAppSnack(context, l10n.absenceApproved);
      }
    } on DomainException catch (e) {
      if (context.mounted) {
        showAppSnack(context, _resolveAbsenceError(e.message, l10n), isError: true);
      }
    }
  }

  Future<void> _reject(
    BuildContext context,
    WidgetRef ref,
    int id,
    AppLocalizations l10n,
  ) async {
    final reasonCtrl = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l10n.absenceReject),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: reasonCtrl,
                decoration: InputDecoration(
                  labelText: l10n.absenceRejectReason,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.absenceRejectConfirmHint,
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: reasonCtrl.text.trim().isEmpty
                  ? null
                  : () => Navigator.pop(ctx, true),
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
    if (confirm != true || !context.mounted) return;

    final reason = reasonCtrl.text.trim();
    if (reason.isEmpty) return;

    try {
      await ref.read(absencesAdminUseCaseProvider).updateAbsenceStatus(
            id: id,
            status: 'REJECTED',
            approvedBy: 'admin',
            rejectReason: reason,
          );
      if (context.mounted) {
        showAppSnack(context, l10n.absenceRejected);
      }
    } on DomainException catch (e) {
      if (context.mounted) {
        showAppSnack(context, _resolveAbsenceError(e.message, l10n), isError: true);
      }
    }
  }
}
