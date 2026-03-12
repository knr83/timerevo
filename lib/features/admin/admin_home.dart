import 'package:flutter/material.dart';
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
        NavigationRail(
          selectedIndex: index,
          onDestinationSelected: (i) =>
              ref.read(adminNavIndexProvider.notifier).state = i,
          labelType: NavigationRailLabelType.all,
          destinations: [
            NavigationRailDestination(
              icon: const Icon(Icons.badge_outlined),
              selectedIcon: const Icon(Icons.badge),
              label: Text(l10n.adminNavEmployees),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.schedule_outlined),
              selectedIcon: const Icon(Icons.schedule),
              label: Text(l10n.adminNavSchedules),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.table_chart_outlined),
              selectedIcon: const Icon(Icons.table_chart),
              label: Text(l10n.adminNavJournal),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.event_busy_outlined),
              selectedIcon: const Icon(Icons.event_busy),
              label: Text(l10n.adminNavAbsences),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.summarize_outlined),
              selectedIcon: const Icon(Icons.summarize),
              label: Text(l10n.adminNavReports),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: Text(l10n.adminNavSettings),
            ),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(child: body),
      ],
    );
  }
}
