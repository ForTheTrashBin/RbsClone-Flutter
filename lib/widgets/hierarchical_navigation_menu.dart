import 'package:flutter/material.dart';

enum NavigationId { welcome, country, custodian, exchange, other }

class NavigationItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final NavigationId navigationId;
  final List<NavigationItem> children;

  String caption = "";

  NavigationItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.navigationId = NavigationId.other,
    this.children = const [],
  });
}

/// Ein einziges hierarchisches Menü mit Hauptkategorien und Sub-Items
/// Ersetzt die bisherige Aufteilung in Sections + MasterEntries
class NavigationMenu extends StatefulWidget {
  const NavigationMenu({
    required this.onItemSelected,
    this.selectedNavigationId,
    this.menuEnabled = true,
    super.key,
  });

  final ValueChanged<NavigationItem> onItemSelected;

  final NavigationId? selectedNavigationId;

  final bool menuEnabled;

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  ///---------------------------------------------------------------------------
  /// Creates the hierarchical navigation menu structure with the
  /// main menu items and their children.
  ///---------------------------------------------------------------------------

  List<NavigationItem> _buildMenuStructure() {
    return [
      NavigationItem(
        title: 'Stammdaten',
        icon: Icons.storage,
        children: [
          NavigationItem(
            title: 'Depot',
            subtitle: 'Stammdaten von Depots',
            icon: Icons.account_balance_wallet,
          ),
          NavigationItem(
            title: 'Verfüger',
            icon: Icons.manage_accounts,
            children: [
              NavigationItem(
                title: 'Verfüger-Stamm',
                subtitle: 'Stammdaten von Verfügern',
                icon: Icons.manage_search,
              ),
              NavigationItem(
                title: 'Verfüger-Konten',
                subtitle: 'Stammdaten von Konten',
                icon: Icons.manage_history,
              ),
              NavigationItem(
                title: 'Internet-Einstellungen',
                subtitle: 'Einstellungen von Verfügern',
                icon: Icons.manage_accounts,
              ),
            ],
          ),
          NavigationItem(
            title: 'Länder',
            subtitle: 'Länderstammdaten',
            icon: Icons.flag,
            navigationId: NavigationId.country,
          ),
          NavigationItem(
            title: 'Lagerstellen',
            subtitle: 'Lagerstellenstammdaten',
            icon: Icons.person,
            navigationId: NavigationId.custodian,
          ),
          NavigationItem(
            title: 'Börsen',
            subtitle: 'Börsenstammdaten',
            icon: Icons.currency_exchange,
            navigationId: NavigationId.exchange,
          ),
        ],
      ),
      NavigationItem(
        title: 'Aufträge',
        icon: Icons.assignment,
        children: [
          NavigationItem(
            title: 'Aufträge-Übersicht',
            subtitle: 'Alle Aufträge im Überblick',
            icon: Icons.assignment,
          ),
          NavigationItem(
            title: 'Aufträge-Details',
            subtitle: 'Details zu einem Auftrag',
            icon: Icons.assignment,
          ),
        ],
      ),
      NavigationItem(
        title: 'Berichte',
        icon: Icons.bar_chart,
        children: [
          NavigationItem(
            title: 'Berichte-Übersicht',
            subtitle: 'Alle Berichte im Überblick',
            icon: Icons.bar_chart,
          ),
          NavigationItem(
            title: 'Berichte-Details',
            subtitle: 'Details zu einem Bericht',
            icon: Icons.bar_chart,
          ),
        ],
      ),
      NavigationItem(
        title: 'Lager',
        icon: Icons.inventory_2,
        children: [
          NavigationItem(
            title: 'Lager-Übersicht',
            subtitle: 'Alle Lager im Überblick',
            icon: Icons.inventory_2,
          ),
          NavigationItem(
            title: 'Lager-Details',
            subtitle: 'Details zu einem Lager',
            icon: Icons.inventory_2,
          ),
        ],
      ),
    ];
  }

  late final List<NavigationItem> items;

  @override
  void initState() {
    super.initState();

    items = _buildMenuStructure();
  }

  @override
  Widget build(BuildContext context) {
    // return _buildFullMode(widget.items);
    return Container(
      //color: Colors.grey.shade300,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, item) {
          return _buildRecursive(context, items[item], "", 0);
        },
      ),
    );
  }

  Widget _buildRecursive(
    BuildContext context,
    NavigationItem item,
    String caption,
    int level,
  ) {
    if (caption.isNotEmpty) {
      caption =
          "$caption \u2192 ${item.title}"; // \u203A \u27A4 \u25BB \u2192 \u21D2
    } else {
      caption = item.title;
    }

    if (item.children.isNotEmpty) {
      return ExpansionTile(
        enabled: widget.menuEnabled,
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
            _buildRecursive(context, subItem, caption, level + 1),
        ],
      );
    } else {
      item.caption = caption;

      return ListTile(
        enabled: widget.menuEnabled,
        leading: Icon(item.icon),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: (level == 0) ? 16.0 : 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: item.subtitle != null
            ? Text(item.subtitle!, style: TextStyle(fontSize: 10))
            : null,
        selected:
            widget.menuEnabled &&
            (widget.selectedNavigationId == item.navigationId),
        selectedTileColor: Theme.of(context).colorScheme.primaryContainer
            .withValues(alpha: 0.3),
        onTap: () => widget.onItemSelected(item),
      );
    }
  }
}
