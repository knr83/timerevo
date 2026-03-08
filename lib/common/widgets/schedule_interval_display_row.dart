import 'package:flutter/material.dart';
import 'package:timerevo/l10n/app_localizations.dart';

import '../../domain/entities/schedule_entities.dart';
import '../utils/time_format.dart';

/// Read-only display of a schedule interval for the week editor.
/// Shows "HH:mm–HH:mm", trash icon for delete, and is tappable to open edit dialog.
/// Uses Material + InkWell for hover/press feedback; delete icon does not trigger edit.
class ScheduleIntervalDisplayRow extends StatelessWidget {
  const ScheduleIntervalDisplayRow({
    super.key,
    required this.interval,
    required this.onTap,
    this.onDelete,
  });

  final ScheduleInterval interval;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final start = TimeFormat.formatMinutes(interval.startMin);
    final end = TimeFormat.formatMinutes(interval.endMin);
    final label = '$start\u2013$end';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.intervalRemoveTooltip,
          ),
        ],
      ),
    );
  }
}
