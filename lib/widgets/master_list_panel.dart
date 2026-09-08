import 'package:flutter/material.dart';

class MasterListPanel extends StatelessWidget {
  const MasterListPanel({
    required this.title,
    required this.entries,
    required this.selectedIndex,
    required this.onSelect,
    this.trailingBuilder,
    super.key,
  });

  final String title;
  final List<MasterSectionEntry> entries;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Widget Function(int index)? trailingBuilder;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entry = entries[index];
                final isSelected = index == selectedIndex;
                return ListTile(
                  dense: true,
                  leading: Icon(entry.icon),
                  title: Text(entry.title),
                  subtitle: Text(entry.subtitle),
                  selected: isSelected,
                  trailing: trailingBuilder != null
                      ? trailingBuilder!(index)
                      : null,
                  onTap: () => onSelect(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MasterSectionEntry {
  const MasterSectionEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
