import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/schedule_entities.dart';

/// Source of the current schedule draft.
sealed class ScheduleDraftSource {
  const ScheduleDraftSource();
}

/// Draft loaded from an existing template.
final class ScheduleDraftSourceExisting extends ScheduleDraftSource {
  const ScheduleDraftSourceExisting(this.templateId);
  final int templateId;
}

/// Draft created via "+ New schedule", not yet persisted.
final class ScheduleDraftSourceNewUnsaved extends ScheduleDraftSource {
  const ScheduleDraftSourceNewUnsaved();
}

/// In-memory draft of a schedule for the week editor.
class ScheduleDraft {
  ScheduleDraft({
    required this.name,
    this.isActive = true,
    required Map<int, DaySchedule> days,
  }) : days = Map<int, DaySchedule>.from(days);

  final String name;
  final bool isActive;
  final Map<int, DaySchedule> days;

  ScheduleDraft copyWith({
    String? name,
    bool? isActive,
    Map<int, DaySchedule>? days,
  }) {
    return ScheduleDraft(
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      days: days ?? Map.from(this.days),
    );
  }
}

String _uniqueDefaultName(List<String> existingNames) {
  const base = 'New schedule';
  final names = existingNames.map((s) => s.trim()).where((s) => s.isNotEmpty).toSet();
  if (!names.contains(base)) return base;
  for (var n = 2; n < 1000; n++) {
    final candidate = '$base ($n)';
    if (!names.contains(candidate)) return candidate;
  }
  return base;
}

/// Default empty week (each day has no intervals).
Map<int, DaySchedule> defaultWeek() {
  return {
    for (var wd = 1; wd <= 7; wd++)
      wd: const DaySchedule(isDayOff: true, intervals: []),
  };
}

/// State for the schedule draft notifier.
class ScheduleDraftState {
  const ScheduleDraftState({
    required this.draft,
    required this.source,
    required this.base,
  });

  final ScheduleDraft draft;
  final ScheduleDraftSource source;
  final Map<int, DaySchedule> base;

  bool get isDirty => _draftDiffersFromBase();

  bool _draftDiffersFromBase() {
    if (draft.days.length != base.length) return true;
    for (var wd = 1; wd <= 7; wd++) {
      final d = draft.days[wd];
      final b = base[wd];
      if (d == null && b == null) continue;
      if (d == null || b == null) return true;
      if (d.isDayOff != b.isDayOff) return true;
      if (d.intervals.length != b.intervals.length) return true;
      for (var i = 0; i < d.intervals.length; i++) {
        final di = d.intervals[i];
        final bi = b.intervals[i];
        if (di.startMin != bi.startMin || di.endMin != bi.endMin) {
          return true;
        }
      }
    }
    return false;
  }
}

/// Notifier for schedule draft state in the week editor.
class ScheduleDraftNotifier extends Notifier<ScheduleDraftState?> {
  @override
  ScheduleDraftState? build() => null;

  void loadFromTemplate(int templateId, Map<int, DaySchedule> week) {
    final base = _deepCopyWeek(week);
    final draft = ScheduleDraft(
      name: '', // Will be set from template info by UI
      isActive: true,
      days: base,
    );
    state = ScheduleDraftState(
      draft: draft,
      source: ScheduleDraftSourceExisting(templateId),
      base: base,
    );
  }

  void loadFromTemplateWithName(
    int templateId,
    String name,
    bool isActive,
    Map<int, DaySchedule> week,
  ) {
    final base = _deepCopyWeek(week);
    final draft = ScheduleDraft(
      name: name,
      isActive: isActive,
      days: base,
    );
    state = ScheduleDraftState(
      draft: draft,
      source: ScheduleDraftSourceExisting(templateId),
      base: base,
    );
  }

  void createNewDraft({List<String> existingNames = const []}) {
    final base = defaultWeek();
    final name = _uniqueDefaultName(existingNames);
    final draft = ScheduleDraft(
      name: name,
      isActive: true,
      days: Map.from(base),
    );
    state = ScheduleDraftState(
      draft: draft,
      source: const ScheduleDraftSourceNewUnsaved(),
      base: base,
    );
  }

  void updateDay(int weekday, DaySchedule day) {
    final s = state;
    if (s == null) return;
    final newDays = Map<int, DaySchedule>.from(s.draft.days);
    newDays[weekday] = day;
    state = ScheduleDraftState(
      draft: s.draft.copyWith(days: newDays),
      source: s.source,
      base: s.base,
    );
  }

  void updateDraftName(String name) {
    final s = state;
    if (s == null) return;
    state = ScheduleDraftState(
      draft: s.draft.copyWith(name: name),
      source: s.source,
      base: s.base,
    );
  }

  void resetToBase() {
    final s = state;
    if (s == null) return;
    state = ScheduleDraftState(
      draft: s.draft.copyWith(days: _deepCopyWeek(s.base)),
      source: s.source,
      base: s.base,
    );
  }

  void clear() {
    state = null;
  }

  void setSourceExisting(int templateId) {
    final s = state;
    if (s == null) return;
    state = ScheduleDraftState(
      draft: s.draft,
      source: ScheduleDraftSourceExisting(templateId),
      base: s.base,
    );
  }

  void markSaved(Map<int, DaySchedule> newBase) {
    final s = state;
    if (s == null) return;
    final base = _deepCopyWeek(newBase);
    state = ScheduleDraftState(
      draft: s.draft.copyWith(days: base),
      source: s.source,
      base: base,
    );
  }

  static Map<int, DaySchedule> _deepCopyWeek(Map<int, DaySchedule> week) {
    return {
      for (final e in week.entries)
        e.key: DaySchedule(
          isDayOff: e.value.isDayOff,
          intervals: [
            for (final i in e.value.intervals)
              ScheduleInterval(
                startMin: i.startMin,
                endMin: i.endMin,
              ),
          ],
        ),
    };
  }
}

final scheduleDraftProvider =
    NotifierProvider<ScheduleDraftNotifier, ScheduleDraftState?>(
  ScheduleDraftNotifier.new,
);

/// Derived: whether the draft has unsaved changes.
final scheduleDraftDirtyProvider = Provider<bool>((ref) {
  return ref.watch(scheduleDraftProvider)?.isDirty ?? false;
});
