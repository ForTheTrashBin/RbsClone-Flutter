import 'package:flutter/material.dart';

class CompactNavigationRail extends StatelessWidget {
  const CompactNavigationRail({
    required this.sections,
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  final List<MainSection> sections;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      minWidth: 72,
      labelType: NavigationRailLabelType.all,
      destinations: [
        for (int index = 0; index < sections.length; index++)
          NavigationRailDestination(
            icon: Icon(sections[index].icon),
            label: Text(sections[index].title),
          ),
      ],
    );
  }
}

class MainSection {
  const MainSection({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
