import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/tokens.dart';
import '../../l10n/app_localizations.dart';
import 'app_drawer.dart';

/// Four tabs with a raised centre FAB (support chat). The bottom bar stays on
/// every form factor; tablets widen content instead (plan §12).
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Scaffold(
      drawer: const AppDrawer(),
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.actionSupport,
        onPressed: () => context.push(AppRoutes.support),
        child: const Icon(Icons.chat_bubble_outline_rounded),
      ),
      bottomNavigationBar: _TabBar(
        index: navigationShell.currentIndex,
        onSelect: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final c = context.colors;
    final tabs = [
      (Icons.home_outlined, Icons.home_rounded, l10n.tabHome),
      (Icons.grid_view_outlined, Icons.grid_view_rounded, l10n.tabCollections),
      (Icons.person_outline_rounded, Icons.person_rounded, l10n.tabProfile),
      (Icons.settings_outlined, Icons.settings_rounded, l10n.tabSettings),
    ];
    return BottomAppBar(
      color: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      padding: EdgeInsets.zero,
      height: AppLayout.tabBarHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: Row(
          children: [
            for (var i = 0; i < tabs.length; i++) ...[
              if (i == 2) const SizedBox(width: AppLayout.fabSize + 16),
              Expanded(
                child: _Tab(
                  icon: index == i ? tabs[i].$2 : tabs[i].$1,
                  label: tabs[i].$3,
                  selected: index == i,
                  onTap: () => onSelect(i),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.primary : c.textMuted;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
