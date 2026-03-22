import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/schedules_providers.dart';
import '../../../app/usecase_providers.dart';
import '../../../core/domain_errors.dart';
import '../../../core/error_message_helper.dart';
import '../../../domain/entities/schedule_entities.dart';
import 'day_card.dart';
import 'schedule_roster_pdf_export.dart';

const _minCardWidth = 240.0;

class SchedulesPage extends ConsumerStatefulWidget {
  const SchedulesPage({super.key});

  @override
  ConsumerState<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends ConsumerState<SchedulesPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final templatesAsync = ref.watch(watchScheduleTemplatesProvider(false));
    final draftState = ref.watch(scheduleDraftProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final dirty = ref.read(scheduleDraftDirtyProvider);
        if (!dirty) {
          if (context.mounted) Navigator.of(context).pop();
          return;
        }
        final action = await _showUnsavedGuardDialog(context);
        if (!context.mounted) return;
        if (action == _GuardAction.cancel) return;
        if (action == _GuardAction.discard) {
          ref.read(scheduleDraftProvider.notifier).clear();
          if (context.mounted) Navigator.of(context).pop();
          return;
        }
        if (action == _GuardAction.save) {
          final ok = await _performSave(ref);
          if (context.mounted && ok) Navigator.of(context).pop();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.schedulesTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  tooltip: l10n.schedulesRosterPdfExportTooltip,
                  icon: const Icon(Symbols.picture_as_pdf),
                  onPressed: () => exportScheduleRosterPdf(context, ref),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: templatesAsync.when(
                data: (templates) {
                  final hasDraft = draftState != null;
                  final hasTemplates = templates.isNotEmpty;

                  if (!hasDraft && !hasTemplates) {
                    return _EmptyState(
                      onNewSchedule: () => ref
                          .read(scheduleDraftProvider.notifier)
                          .createNewDraft(),
                    );
                  }

                  if (!hasDraft && hasTemplates) {
                    return _InitialTemplateLoader(
                      templateId: templates.first.id,
                      templates: templates,
                      onLoaded: (week) {
                        final t = templates.first;
                        ref
                            .read(scheduleDraftProvider.notifier)
                            .loadFromTemplateWithName(
                              t.id,
                              t.name,
                              t.isActive,
                              week,
                            );
                      },
                    );
                  }

                  return _WeekEditorContent(
                    templates: templates,
                    draftState: draftState!,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    l10n.schedulesFailedLoad(
                      errorMessageForUser(e, l10n.commonErrorOccurred),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<_GuardAction?> _showUnsavedGuardDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    return showDialog<_GuardAction>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.schedulesUnsavedChangesTitle),
        content: Text(l10n.schedulesUnsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_GuardAction.cancel),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(_GuardAction.discard),
            child: Text(l10n.schedulesDiscardChanges),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_GuardAction.save),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }

  Future<bool> _performSave(WidgetRef ref) async {
    final useCase = ref.read(schedulesTemplatesUseCaseProvider);
    final draftState = ref.read(scheduleDraftProvider);
    if (draftState == null) return true;
    final ctx = context;

    try {
      if (draftState.source is ScheduleDraftSourceNewUnsaved) {
        final id = await useCase.createTemplateWithWeek(
          name: draftState.draft.name,
          days: draftState.draft.days,
        );
        ref
            .read(scheduleDraftProvider.notifier)
            .markSaved(draftState.draft.days);
        ref.read(scheduleDraftProvider.notifier).setSourceExisting(id);
      } else {
        final src = draftState.source as ScheduleDraftSourceExisting;
        await useCase.saveTemplateWeek(
          templateId: src.templateId,
          days: draftState.draft.days,
        );
        ref
            .read(scheduleDraftProvider.notifier)
            .markSaved(draftState.draft.days);
      }
      return true;
    } catch (e) {
      if (!ctx.mounted) return false;
      final l10n = AppLocalizations.of(ctx);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            l10n.schedulesSaveFailed(
              errorMessageForUser(e, l10n.commonErrorOccurred),
            ),
          ),
        ),
      );
      return false;
    }
  }
}

enum _GuardAction { cancel, discard, save }

class _RenameScheduleDialog extends ConsumerStatefulWidget {
  const _RenameScheduleDialog({
    required this.initialName,
    required this.isExisting,
    this.templateId,
  });

  final String initialName;
  final bool isExisting;
  final int? templateId;

  @override
  ConsumerState<_RenameScheduleDialog> createState() =>
      _RenameScheduleDialogState();
}

class _RenameScheduleDialogState extends ConsumerState<_RenameScheduleDialog> {
  late final TextEditingController _controller;
  String? _fieldError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(
        () => _fieldError = AppLocalizations.of(
          context,
        ).schedulesNameRequiredError,
      );
      return;
    }
    setState(() {
      _fieldError = null;
      _isSaving = true;
    });

    try {
      if (widget.isExisting && widget.templateId != null) {
        final useCase = ref.read(schedulesTemplatesUseCaseProvider);
        await useCase.updateTemplateName(id: widget.templateId!, name: name);
        ref.invalidate(watchScheduleTemplatesProvider(false));
      }
      ref.read(scheduleDraftProvider.notifier).updateDraftName(name);
      if (mounted) Navigator.of(context).pop();
    } on DomainConstraintException {
      if (mounted) {
        setState(() {
          _fieldError = AppLocalizations.of(
            context,
          ).schedulesNameAlreadyExistsError;
          _isSaving = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).schedulesSaveFailed(
                errorMessageForUser(
                  e,
                  AppLocalizations.of(context).commonErrorOccurred,
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.schedulesRenameTemplateTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: l10n.schedulesTemplateNameLabel,
              border: const OutlineInputBorder(),
              errorText: _fieldError,
            ),
            enabled: !_isSaving,
            onChanged: (_) => setState(() => _fieldError = null),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
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

/// Loads the first template's week and triggers onLoaded, then shows progress.
class _InitialTemplateLoader extends ConsumerWidget {
  const _InitialTemplateLoader({
    required this.templateId,
    required this.templates,
    required this.onLoaded,
  });

  final int templateId;
  final List<ScheduleTemplateInfo> templates;
  final void Function(Map<int, DaySchedule> week) onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekAsync = ref.watch(watchTemplateWeekProvider(templateId));
    return weekAsync.when(
      data: (week) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onLoaded(week);
        });
        return const Center(child: CircularProgressIndicator());
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          AppLocalizations.of(context).schedulesFailedLoadTemplate(
            errorMessageForUser(
              e,
              AppLocalizations.of(context).commonErrorOccurred,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onNewSchedule});

  final VoidCallback onNewSchedule;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.schedulesEmptyHint),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onNewSchedule,
            icon: const Icon(Symbols.add),
            label: Text(l10n.schedulesNewSchedule),
          ),
        ],
      ),
    );
  }
}

class _WeekEditorContent extends ConsumerWidget {
  const _WeekEditorContent({required this.templates, required this.draftState});

  final List<ScheduleTemplateInfo> templates;
  final ScheduleDraftState draftState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dirty = ref.watch(scheduleDraftDirtyProvider);
    final draft = draftState.draft;
    final source = draftState.source;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WeekEditorControlRow(
          templates: templates,
          draft: draft,
          source: source,
          dirty: dirty,
          onSelectTemplate: (id) => _onSelectTemplate(context, ref, id),
          onNewSchedule: () => _onNewSchedule(context, ref),
          onRename: () => _onRename(context, ref),
          onDelete: () => _onDelete(context, ref),
          onSave: () => _onSave(context, ref),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 12.0;
              final cols = (constraints.maxWidth / _minCardWidth).floor().clamp(
                1,
                7,
              );
              final cardWidth =
                  (constraints.maxWidth - (cols - 1) * spacing) / cols;
              return SingleChildScrollView(
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (var wd = 1; wd <= 7; wd++)
                      SizedBox(
                        width: cardWidth,
                        child: WeekEditorDayCard(
                          weekday: wd,
                          day:
                              draft.days[wd] ??
                              const DaySchedule(isDayOff: true, intervals: []),
                          onUpdateDay: (day) => ref
                              .read(scheduleDraftProvider.notifier)
                              .updateDay(wd, day),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _onSelectTemplate(
    BuildContext context,
    WidgetRef ref,
    int templateId,
  ) async {
    final dirty = ref.read(scheduleDraftDirtyProvider);
    if (!dirty) {
      await _loadTemplate(context, ref, templateId);
      return;
    }
    final action = await _showGuardDialog(context);
    if (!context.mounted) return;
    if (action == _GuardAction.cancel) return;
    if (action == _GuardAction.discard) {
      ref.read(scheduleDraftProvider.notifier).clear();
      await _loadTemplate(context, ref, templateId);
      return;
    }
    if (action == _GuardAction.save) {
      final ok = await _save(context, ref);
      if (context.mounted && ok) await _loadTemplate(context, ref, templateId);
    }
  }

  Future<void> _onRename(BuildContext context, WidgetRef ref) async {
    final dirty = ref.read(scheduleDraftDirtyProvider);
    if (!dirty) {
      await _showRenameScheduleDialog(context, ref);
      return;
    }
    final action = await _showGuardDialog(context);
    if (!context.mounted) return;
    if (action == _GuardAction.cancel) return;
    if (action == _GuardAction.discard) {
      ref.read(scheduleDraftProvider.notifier).resetToBase();
      if (context.mounted) await _showRenameScheduleDialog(context, ref);
      return;
    }
    if (action == _GuardAction.save) {
      final ok = await _save(context, ref);
      if (context.mounted && ok) await _showRenameScheduleDialog(context, ref);
    }
  }

  Future<void> _onDelete(BuildContext context, WidgetRef ref) async {
    final source = ref.read(scheduleDraftProvider)?.source;
    final existing = source is ScheduleDraftSourceExisting ? source : null;
    if (existing == null) return;
    final templateId = existing.templateId;

    final dirty = ref.read(scheduleDraftDirtyProvider);
    if (!dirty) {
      await _showDeleteConfirmDialog(context, ref, templateId);
      return;
    }
    final action = await _showGuardDialog(context);
    if (!context.mounted) return;
    if (action == _GuardAction.cancel) return;
    if (action == _GuardAction.discard) {
      ref.read(scheduleDraftProvider.notifier).resetToBase();
      if (context.mounted) {
        await _showDeleteConfirmDialog(context, ref, templateId);
      }
      return;
    }
    if (action == _GuardAction.save) {
      final ok = await _save(context, ref);
      if (context.mounted && ok) {
        await _showDeleteConfirmDialog(context, ref, templateId);
      }
    }
  }

  Future<void> _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    int templateId,
  ) async {
    final l10n = AppLocalizations.of(context);

    final assigned = await ref
        .read(schedulesTemplatesUseCaseProvider)
        .hasAssignments(templateId);
    if (assigned) {
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.schedulesDeleteBlockedAssignedTitle),
          content: Text(l10n.schedulesDeleteBlockedAssignedMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.commonOk),
            ),
          ],
        ),
      );
      return;
    }

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.schedulesDeleteScheduleTitle),
        content: Text(l10n.schedulesDeleteScheduleMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l10n.schedulesDeleteScheduleButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref
          .read(schedulesTemplatesUseCaseProvider)
          .deleteTemplate(templateId);
      ref.read(scheduleDraftProvider.notifier).clear();
      ref.invalidate(watchScheduleTemplatesProvider(false));
    } on DomainConstraintException catch (e) {
      if (e.message == 'schedulesTemplateAssigned') {
        if (!context.mounted) return;
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.schedulesDeleteBlockedAssignedTitle),
            content: Text(l10n.schedulesDeleteBlockedAssignedMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.commonOk),
              ),
            ],
          ),
        );
        return;
      }
      rethrow;
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.schedulesDeleteFailed(
              errorMessageForUser(e, l10n.commonErrorOccurred),
            ),
          ),
        ),
      );
    }
  }

  Future<void> _loadTemplate(
    BuildContext context,
    WidgetRef ref,
    int templateId,
  ) async {
    final useCase = ref.read(schedulesTemplatesUseCaseProvider);
    final week = await useCase.getTemplateWeek(templateId);
    if (!context.mounted) return;
    final templates = ref.read(watchScheduleTemplatesProvider(false)).value;
    final t = templates?.firstWhere(
      (x) => x.id == templateId,
      orElse: () => ScheduleTemplateInfo(
        id: templateId,
        name: '',
        isActive: true,
        weeklyTotalWorkMinutes: 0,
      ),
    );
    ref
        .read(scheduleDraftProvider.notifier)
        .loadFromTemplateWithName(
          templateId,
          t?.name ?? '',
          t?.isActive ?? true,
          week,
        );
  }

  Future<void> _onNewSchedule(BuildContext context, WidgetRef ref) async {
    final dirty = ref.read(scheduleDraftDirtyProvider);
    final existingNames = templates.map((t) => t.name).toList();
    if (!dirty) {
      ref
          .read(scheduleDraftProvider.notifier)
          .createNewDraft(existingNames: existingNames);
      return;
    }
    final action = await _showGuardDialog(context);
    if (!context.mounted) return;
    if (action == _GuardAction.cancel) return;
    if (action == _GuardAction.discard) {
      ref.read(scheduleDraftProvider.notifier).clear();
      ref
          .read(scheduleDraftProvider.notifier)
          .createNewDraft(existingNames: existingNames);
      return;
    }
    if (action == _GuardAction.save) {
      final ok = await _save(context, ref);
      if (context.mounted && ok) {
        final draft = ref.read(scheduleDraftProvider);
        final names = [...existingNames, if (draft != null) draft.draft.name];
        ref
            .read(scheduleDraftProvider.notifier)
            .createNewDraft(existingNames: names);
      }
    }
  }

  Future<void> _onSave(BuildContext context, WidgetRef ref) async {
    await _save(context, ref);
  }

  Future<bool> _save(BuildContext context, WidgetRef ref) async {
    final useCase = ref.read(schedulesTemplatesUseCaseProvider);
    final draftState = ref.read(scheduleDraftProvider);
    if (draftState == null) return true;

    try {
      if (draftState.source is ScheduleDraftSourceNewUnsaved) {
        final id = await useCase.createTemplateWithWeek(
          name: draftState.draft.name,
          days: draftState.draft.days,
        );
        ref
            .read(scheduleDraftProvider.notifier)
            .markSaved(draftState.draft.days);
        ref.read(scheduleDraftProvider.notifier).setSourceExisting(id);
      } else {
        final src = draftState.source as ScheduleDraftSourceExisting;
        await useCase.saveTemplateWeek(
          templateId: src.templateId,
          days: draftState.draft.days,
        );
        ref
            .read(scheduleDraftProvider.notifier)
            .markSaved(draftState.draft.days);
      }
      return true;
    } catch (e) {
      if (!context.mounted) return false;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.schedulesSaveFailed(
              errorMessageForUser(e, l10n.commonErrorOccurred),
            ),
          ),
        ),
      );
      return false;
    }
  }

  Future<_GuardAction?> _showGuardDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    return showDialog<_GuardAction>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.schedulesUnsavedChangesTitle),
        content: Text(l10n.schedulesUnsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_GuardAction.cancel),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(_GuardAction.discard),
            child: Text(l10n.schedulesDiscardChanges),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_GuardAction.save),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }

  Future<void> _showRenameScheduleDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final draftState = ref.read(scheduleDraftProvider);
    if (draftState == null) return;
    final initialName = draftState.draft.name;
    final isExisting = draftState.source is ScheduleDraftSourceExisting;
    final templateId = isExisting
        ? (draftState.source as ScheduleDraftSourceExisting).templateId
        : null;

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => _RenameScheduleDialog(
        initialName: initialName,
        isExisting: isExisting,
        templateId: templateId,
      ),
    );
  }
}

class _WeekEditorControlRow extends StatelessWidget {
  const _WeekEditorControlRow({
    required this.templates,
    required this.draft,
    required this.source,
    required this.dirty,
    required this.onSelectTemplate,
    required this.onNewSchedule,
    required this.onRename,
    required this.onDelete,
    required this.onSave,
  });

  final List<ScheduleTemplateInfo> templates;
  final ScheduleDraft draft;
  final ScheduleDraftSource source;
  final bool dirty;
  final ValueChanged<int> onSelectTemplate;
  final VoidCallback onNewSchedule;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isNew = source is ScheduleDraftSourceNewUnsaved;
    final currentId = source is ScheduleDraftSourceExisting
        ? (source as ScheduleDraftSourceExisting).templateId
        : null;

    final displayName = draft.name;
    final suffix = draft.isActive
        ? l10n.schedulesScheduleActiveSuffix
        : l10n.schedulesScheduleInactiveSuffix;
    final fullLabel = '$displayName$suffix';

    return Row(
      children: [
        DropdownMenu<int>(
          initialSelection: isNew ? -1 : currentId,
          dropdownMenuEntries: [
            if (isNew) DropdownMenuEntry(value: -1, label: fullLabel),
            ...templates.map(
              (t) => DropdownMenuEntry(
                value: t.id,
                label:
                    '${t.name}${t.isActive ? l10n.schedulesScheduleActiveSuffix : l10n.schedulesScheduleInactiveSuffix}',
              ),
            ),
          ],
          onSelected: (id) {
            if (id == null) return;
            if (id == -1) return; // New draft, keep selected
            onSelectTemplate(id);
          },
        ),
        Tooltip(
          message: l10n.schedulesRenameScheduleTooltip,
          child: IconButton(
            icon: const Icon(Symbols.edit),
            onPressed: onRename,
          ),
        ),
        Tooltip(
          message: l10n.schedulesDeleteScheduleTooltip,
          child: IconButton(
            icon: const Icon(Symbols.delete),
            onPressed: isNew ? null : onDelete,
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: l10n.schedulesNewSchedule,
          child: FilledButton.tonal(
            onPressed: onNewSchedule,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Symbols.add),
                const SizedBox(width: 8),
                Text(l10n.schedulesNewSchedule),
              ],
            ),
          ),
        ),
        const Spacer(),
        FilledButton(
          onPressed: dirty ? onSave : null,
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
