import 'package:flutter/material.dart';

/// Hierarchisches Navigationselement
class NavigationItem {
  final String title;
  final IconData icon;
  final String? subtitle;
  final VoidCallback? onTap;
  final List<NavigationItem> children;
  final bool isHighlighted;

  NavigationItem({
    required this.title,
    required this.icon,
    this.subtitle,
    this.onTap,
    this.children = const [],
    this.isHighlighted = false,
  });
}

/// Ein einziges hierarchisches Menü mit Hauptkategorien und Sub-Items
/// Ersetzt die bisherige Aufteilung in Sections + MasterEntries
class HierarchicalNavigationMenu extends StatefulWidget {
  const HierarchicalNavigationMenu({
    required this.items,
    required this.onItemSelected,
    this.selectedTitle,
    super.key,
  });

  /// Hierarchische Menü-Struktur (Hauptkategorien + Sub-Items)
  final List<NavigationItem> items;

  /// Callback wenn ein Element ausgewählt wird
  final ValueChanged<NavigationItem> onItemSelected;

  /// Der aktuell ausgewählte Item (für Highlighting)
  final String? selectedTitle;

  @override
  State<HierarchicalNavigationMenu> createState() =>
      _HierarchicalNavigationMenuState();
}

class _HierarchicalNavigationMenuState
    extends State<HierarchicalNavigationMenu> {
  @override
  Widget build(BuildContext context) {
    // return _buildFullMode(widget.items);
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, item) {
        return _buildRecursive(context, widget.items[item], 0);
      },
    );
  }

  Widget _buildRecursive(BuildContext context, NavigationItem item, int level) {
    if (item.children.isNotEmpty) {
      return ExpansionTile(
        childrenPadding: EdgeInsets.only(left: 16.0),
        leading: Icon(item.icon),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: (level == 0) ? 16.0 : 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: item.subtitle != null
            ? Text(item.subtitle!, style: const TextStyle(fontSize: 12))
            : null,
        children: [
          for (var subItem in item.children)
            _buildRecursive(context, subItem, level + 1),
        ],
      );
    } else {
      return ListTile(
        leading: Icon(item.icon),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: (level == 0) ? 16.0 : 14.0,
            fontWeight: FontWeight.w600,
            color: widget.selectedTitle == item.title
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
        ),
        subtitle: item.subtitle != null
            ? Text(
                item.subtitle!,
                style: TextStyle(
                  fontSize: 10,
                  color: widget.selectedTitle == item.title
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              )
            : null,
        selected: widget.selectedTitle == item.title,
        selectedTileColor: Theme.of(context).colorScheme.primaryContainer
            .withValues(alpha: 0.3),
        onTap: () => widget.onItemSelected(item),
      );
    }
  }
}
