import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../../domain/entities/schedule_entities.dart';
import '../../../common/utils/time_format.dart';

/// Result of the interval edit/add dialog.
class IntervalDialogResult {
  const IntervalDialogResult({required this.startMin, required this.endMin});
  final int startMin;
  final int endMin;
}

/// Shows a dialog to edit or add a schedule interval.
/// Returns null on Cancel, or the new start/end minutes on Save.
Future<IntervalDialogResult?> showIntervalEditDialog({
  required BuildContext context,
  required bool isAdd,
  required List<ScheduleInterval> existingIntervals,
  ScheduleInterval? initial,
}) {
  return showDialog<IntervalDialogResult>(
    context: context,
    builder: (context) => _IntervalEditDialog(
      isAdd: isAdd,
      existingIntervals: existingIntervals,
      initial: initial,
    ),
  );
}

class _IntervalEditDialog extends StatefulWidget {
  const _IntervalEditDialog({
    required this.isAdd,
    required this.existingIntervals,
    this.initial,
  });

  final bool isAdd;
  final List<ScheduleInterval> existingIntervals;
  final ScheduleInterval? initial;

  @override
  State<_IntervalEditDialog> createState() => _IntervalEditDialogState();
}

class _IntervalEditDialogState extends State<_IntervalEditDialog> {
  late int _startMin;
  late int _endMin;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _startMin = widget.initial!.startMin;
      _endMin = widget.initial!.endMin;
    } else {
      _startMin = 9 * 60;
      _endMin = 12 * 60;
    }
  }

  String? _validate() {
    final l10n = AppLocalizations.of(context);
    if (_endMin <= _startMin) {
      return l10n.schedulesIntervalEndBeforeStartError;
    }
    final edited = ScheduleInterval(startMin: _startMin, endMin: _endMin);
    if (_overlapsWithOthers(edited, widget.existingIntervals, widget.initial)) {
      return l10n.schedulesIntervalOverlapError;
    }
    return null;
  }

  bool _overlapsWithOthers(
    ScheduleInterval interval,
    List<ScheduleInterval> others,
    ScheduleInterval? exclude,
  ) {
    for (final other in others) {
      if (exclude != null &&
          other.startMin == exclude.startMin &&
          other.endMin == exclude.endMin) {
        continue;
      }
      if (_intervalsOverlap(interval, other)) return true;
    }
    return false;
  }

  bool _intervalsOverlap(ScheduleInterval a, ScheduleInterval b) {
    return a.startMin < b.endMin && b.startMin < a.endMin;
  }

  Future<void> _pickStart() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeFormat.timeOfDayFromMinutes(_startMin),
    );
    if (picked != null && mounted) {
      setState(() => _startMin = picked.hour * 60 + picked.minute);
    }
  }

  Future<void> _pickEnd() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeFormat.timeOfDayFromMinutes(_endMin),
    );
    if (picked != null && mounted) {
      setState(() => _endMin = picked.hour * 60 + picked.minute);
    }
  }

  void _cancel() => Navigator.of(context).pop();

  void _trySave() {
    if (_validate() == null) {
      Navigator.of(
        context,
      ).pop(IntervalDialogResult(startMin: _startMin, endMin: _endMin));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = widget.isAdd
        ? l10n.schedulesAddIntervalTitle
        : l10n.schedulesEditIntervalTitle;
    final error = _validate();

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _cancel,
        const SingleActivator(LogicalKeyboardKey.enter): _trySave,
      },
      child: Focus(
        autofocus: true,
        child: AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.schedulesStartTimeLabel),
                        const SizedBox(height: 4),
                        OutlinedButton(
                          onPressed: _pickStart,
                          child: Text(TimeFormat.formatMinutes(_startMin)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.schedulesEndTimeLabel),
                        const SizedBox(height: 4),
                        OutlinedButton(
                          onPressed: _pickEnd,
                          child: Text(TimeFormat.formatMinutes(_endMin)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(
                  error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: _cancel, child: Text(l10n.commonCancel)),
            FilledButton(
              onPressed: error != null ? null : _trySave,
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }
}
