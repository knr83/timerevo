import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timerevo/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'absences/absences_page.dart';
import 'employees/employees_page.dart';
import 'reports/reports_page.dart';
import 'schedules/schedules_page.dart';
import 'sessions/sessions_page.dart';
import 'settings/settings_page.dart';

final adminNavIndexProvider = StateProvider<int>((ref) => 0);

const double _railMinWidth = 72.0;

class AdminHome extends ConsumerWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final index = ref.watch(adminNavIndexProvider);

    final body = switch (index) {
      0 => const EmployeesPage(),
      1 => const SchedulesPage(),
      2 => const SessionsPage(),
      3 => const AbsencesPage(),
      4 => const ReportsPage(),
      _ => const SettingsPage(),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AdminNavRail(
          selectedIndex: index,
          onDestinationSelected: (i) =>
              ref.read(adminNavIndexProvider.notifier).state = i,
          destinations: [
            _NavItem(icon: Symbols.badge, label: l10n.adminNavEmployees),
            _NavItem(icon: Symbols.schedule, label: l10n.adminNavSchedules),
            _NavItem(icon: Symbols.table_chart, label: l10n.adminNavJournal),
            _NavItem(icon: Symbols.event_busy, label: l10n.adminNavAbsences),
            _NavItem(icon: Symbols.summarize, label: l10n.adminNavReports),
            _NavItem(icon: Symbols.settings, label: l10n.adminNavSettings),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(child: body),
      ],
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _AdminNavRail extends StatelessWidget {
  const _AdminNavRail({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<_NavItem> destinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navTheme = theme.navigationRailTheme;
    final cs = theme.colorScheme;

    final unselectedLabelStyle =
        navTheme.unselectedLabelTextStyle ??
        theme.textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant) ??
        TextStyle(color: cs.onSurfaceVariant, fontSize: 12);
    final selectedLabelStyle =
        navTheme.selectedLabelTextStyle ??
        theme.textTheme.labelMedium?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w500,
        ) ??
        TextStyle(color: cs.primary, fontSize: 12, fontWeight: FontWeight.w500);

    return Material(
      color: navTheme.backgroundColor ?? cs.surface,
      child: IntrinsicWidth(
        stepWidth: 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: _railMinWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < destinations.length; i++) ...[
                _NavRailTile(
                  icon: destinations[i].icon,
                  label: destinations[i].label,
                  selected: i == selectedIndex,
                  onTap: () => onDestinationSelected(i),
                  unselectedLabelStyle: unselectedLabelStyle,
                  selectedLabelStyle: selectedLabelStyle,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavRailTile extends StatelessWidget {
  const _NavRailTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.unselectedLabelStyle,
    required this.selectedLabelStyle,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final TextStyle unselectedLabelStyle;
  final TextStyle selectedLabelStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final primaryAlpha = cs.primary.a < 1.0;
    final selectedColor = primaryAlpha
        ? cs.primary
        : cs.primary.withValues(alpha: 0.12);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(color: selected ? selectedColor : null),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 40,
                    opticalSize: 40,
                    fill: selected ? 1 : 0,
                    color: selected ? cs.primary : cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: selected ? selectedLabelStyle : unselectedLabelStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
