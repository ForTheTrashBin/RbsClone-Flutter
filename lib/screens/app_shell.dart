import 'package:flutter/material.dart';
import 'package:rbsclone_flutter/widgets/hierarchical_navigation_menu.dart';
import 'package:rbsclone_flutter/widgets/placeholder_page.dart';
import 'package:rbsclone_flutter/widgets/adaptive_layout.dart';

import 'country/country_detail_page.dart';
import 'country/country_form_dialog.dart';
import 'custodian/custodian_detail_page.dart';
import 'custodian/custodian_form_dialog.dart';
import 'exchange/exchange_detail_page.dart';
import 'exchange/exchange_form_dialog.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // late final CountryRepository _countryRepository = CountryRepository();
  // late final CustodianRepository _custodianRepository = CustodianRepository();
  // late final ExchangeRepository _exchangeRepository = ExchangeRepository();

  /// Welcher Menü-Item ist aktuell ausgewählt?

  String _selectedMenuItemTitle = 'WELCOME';

  int _mobileViewIndex = 0; // 0=Menü, 1=Liste, 2=Detail
  /*
  String? _selectedCountryId;
  String? _selectedCustodianId;
  String? _selectedExchangeId;

  bool _loadingCountries = true;
  String? _countriesError;
  List<CountryListItem> _countries = const [];

  bool _loadingCustodians = true;
  String? _custodiansError;
  List<CustodianListItem> _custodians = const [];

  bool _loadingExchanges = true;
  String? _exchangesError;
  List<ExchangeListItem> _exchanges = const [];

  @override
  void initState() {
    super.initState();
    // _loadCountries();
    // _loadCustodians();
    // _loadExchanges();
  }
  */
  /*
  Future<void> _loadCountries() async {
    setState(() {
      _loadingCountries = true;
      _countriesError = null;
    });
    try {
      final items = await _countryRepository.fetchCountries();
      if (!mounted) return;
      setState(() {
        _countries = items;
        _loadingCountries = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingCountries = false;
        _countriesError = e.toString();
      });
    }
  }

  Future<void> _loadCustodians() async {
    setState(() {
      _loadingCustodians = true;
      _custodiansError = null;
    });
    try {
      final items = await _custodianRepository.fetchCustodians();
      if (!mounted) return;
      setState(() {
        _custodians = items;
        _loadingCustodians = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingCustodians = false;
        _custodiansError = e.toString();
      });
    }
  }

  Future<void> _loadExchanges() async {
    setState(() {
      _loadingExchanges = true;
      _exchangesError = null;
    });
    try {
      final items = await _exchangeRepository.fetchExchanges();
      if (!mounted) return;
      setState(() {
        _exchanges = items;
        _loadingExchanges = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingExchanges = false;
        _exchangesError = e.toString();
      });
    }
  }
*/
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
            onTap: () => setState(() => _selectedMenuItemTitle = 'Depot'),
          ),
          NavigationItem(
            title: 'Verfüger',
            icon: Icons.manage_accounts,
            children: [
              NavigationItem(
                title: 'Verfüger-Stamm',
                subtitle: 'Stammdaten von Verfügern',
                icon: Icons.manage_search,
                onTap: () =>
                    setState(() => _selectedMenuItemTitle = 'Verfüger-Stamm'),
              ),
              NavigationItem(
                title: 'Verfüger-Konten',
                subtitle: 'Stammdaten von Konten',
                icon: Icons.manage_history,
                onTap: () =>
                    setState(() => _selectedMenuItemTitle = 'Verfüger-Konten'),
              ),
              NavigationItem(
                title: 'Internet-Einstellungen',
                subtitle: 'Einstellungen von Verfügern',
                icon: Icons.manage_accounts,
                onTap: () => setState(
                  () => _selectedMenuItemTitle = 'Internet-Einstellungen',
                ),
              ),
            ],
          ),
          NavigationItem(
            title: 'Länder',
            subtitle: 'Länderstammdaten',
            icon: Icons.flag,
            onTap: () => setState(() => _selectedMenuItemTitle = 'Länder'),
          ),
          NavigationItem(
            title: 'Lagerstellen',
            subtitle: 'Lagerstellenstammdaten',
            icon: Icons.person,
            onTap: () =>
                setState(() => _selectedMenuItemTitle = 'Lagerstellen'),
          ),
          NavigationItem(
            title: 'Börsen',
            subtitle: 'Börsenstammdaten',
            icon: Icons.currency_exchange,
            onTap: () => setState(() => _selectedMenuItemTitle = 'Börsen'),
          ),
        ],
      ),
      NavigationItem(
        title: 'Aufträge',
        icon: Icons.assignment,
        children: [
          NavigationItem(
            title: 'Aufträge - Übersicht',
            subtitle: 'Alle Aufträge im Überblick',
            icon: Icons.assignment,
            onTap: () =>
                setState(() => _selectedMenuItemTitle = 'Aufträge - Übersicht'),
          ),
          NavigationItem(
            title: 'Aufträge - Details',
            subtitle: 'Details zu einem Auftrag',
            icon: Icons.assignment,
            onTap: () =>
                setState(() => _selectedMenuItemTitle = 'Aufträge - Details'),
          ),
        ],
      ),
      NavigationItem(
        title: 'Berichte',
        icon: Icons.bar_chart,
        children: [
          NavigationItem(
            title: 'Berichte - Übersicht',
            subtitle: 'Alle Berichte im Überblick',
            icon: Icons.bar_chart,
            onTap: () =>
                setState(() => _selectedMenuItemTitle = 'Berichte - Übersicht'),
          ),
          NavigationItem(
            title: 'Berichte - Details',
            subtitle: 'Details zu einem Bericht',
            icon: Icons.bar_chart,
            onTap: () =>
                setState(() => _selectedMenuItemTitle = 'Berichte - Details'),
          ),
        ],
      ),
      NavigationItem(
        title: 'Lager',
        icon: Icons.inventory_2,
        children: [
          NavigationItem(
            title: 'Lager - Übersicht',
            subtitle: 'Alle Lager im Überblick',
            icon: Icons.inventory_2,
            onTap: () =>
                setState(() => _selectedMenuItemTitle = 'Lager - Übersicht'),
          ),
          NavigationItem(
            title: 'Lager - Details',
            subtitle: 'Details zu einem Lager',
            icon: Icons.inventory_2,
            onTap: () =>
                setState(() => _selectedMenuItemTitle = 'Lager - Details'),
          ),
        ],
      ),
    ];
  }

  /// Gibt den aktuellen Hauptinhalt basierend auf der Auswahl zurück
  Widget _buildMainContent() {
    switch (_selectedMenuItemTitle) {
      case 'WELCOME':
        return const PlaceholderPage(title: 'Willkommen!');

      case 'Länder':
        return CountryDataModule();
      /*
        return CountryMasterPanel(
          countries: _countries,
          loading: _loadingCountries,
          error: _countriesError,
          selectedCountry: _selectedCountry,
          onSelectCountry: (country) =>
              setState(() => _selectedCountryId = country.id),
          onRefresh: _loadCountries,
          onNewCountry: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => const CountryFormDialog(),
            );
            if (result == true) await _loadCountries();
          },
          onEditCountry: (country) async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => CountryFormDialog(country: country),
            );
            if (result == true) await _loadCountries();
          },
          onDeleteCountry: _deleteCountry,
        );
*/
      case 'Lagerstellen':
        return CustodianDataModule();
      /*
        return CustodianMasterList(
          onItemSelected: (_) {
            print("Item selected");
          },
        );*/
      /*
        return CustodianMasterPanel(
          custodians: _custodians,
          countries: _countries,
          loading: _loadingCustodians,
          error: _custodiansError,
          selectedCustodian: _selectedCustodian,
          onSelectCustodian: (custodian) =>
              setState(() => _selectedCustodianId = custodian.id),
          onRefresh: _loadCustodians,
          onNewCustodian: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => CustodianFormDialog(countries: _countries),
            );
            if (result == true) await _loadCustodians();
          },
          onEditCustodian: (custodian) async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => CustodianFormDialog(
                countries: _countries,
                custodian: custodian,
              ),
            );
            if (result == true) await _loadCustodians();
          },
          onDeleteCustodian: _deleteCustodian,
        );
        */
      case 'Börsen':
        return ExchangeDataModule();
      /*
        return ExchangeMasterList(
          onItemSelected: (_) {
            print("Item selected");
          },
        );*/
      /*
        return ExchangeMasterPanel(
          exchanges: _exchanges,
          loading: _loadingExchanges,
          error: _exchangesError,
          selectedExchange: _selectedExchange,
          onSelectExchange: (exchange) =>
              setState(() => _selectedExchangeId = exchange.id),
          onRefresh: _loadExchanges,
          onNewExchange: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => const ExchangeFormDialog(),
            );
            if (result == true) await _loadExchanges();
          },
          onEditExchange: (exchange) async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => ExchangeFormDialog(exchange: exchange),
            );
            if (result == true) await _loadExchanges();
          },
          onDeleteExchange: _deleteExchange,
        );
*/
      default:
        return const PlaceholderPage(title: 'In Arbeit');
    }
  }

  /*
  CountryListItem? get _selectedCountry {
    if (_selectedMenuItemTitle != 'Länder' || _countries.isEmpty) return null;
    final selectedId = _selectedCountryId ?? _countries.first.id;
    return _countries.firstWhere(
      (c) => c.id == selectedId,
      orElse: () => _countries.first,
    );
  }

  CustodianListItem? get _selectedCustodian {
    if (_selectedMenuItemTitle != 'Lagerstellen' || _custodians.isEmpty) {
      return null;
    }
    final selectedId = _selectedCustodianId ?? _custodians.first.id;
    return _custodians.firstWhere(
      (c) => c.id == selectedId,
      orElse: () => _custodians.first,
    );
  }

  ExchangeListItem? get _selectedExchange {
    if (_selectedMenuItemTitle != 'Börsen' || _exchanges.isEmpty) return null;
    final selectedId = _selectedExchangeId ?? _exchanges.first.id;
    return _exchanges.firstWhere(
      (e) => e.id == selectedId,
      orElse: () => _exchanges.first,
    );
  }
*/
  /*
  Future<void> _deleteCountry(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Land löschen?'),
        content: const Text('Die Daten werden dauerhaft entfernt.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _countryRepository.deleteCountry(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Land wurde gelöscht.')));
      await _loadCountries();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  Future<void> _deleteCustodian(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lagerstelle löschen?'),
        content: const Text('Die Daten werden dauerhaft entfernt.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _custodianRepository.deleteCustodian(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lagerstelle wurde gelöscht.')),
      );
      await _loadCustodians();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  Future<void> _deleteExchange(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Börse löschen?'),
        content: const Text('Die Daten werden dauerhaft entfernt.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _exchangeRepository.deleteExchange(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Börse wurde gelöscht.')));
      await _loadExchanges();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveBreakpoints.getScreenSize(context);
    final menuStructure = _buildMenuStructure();

    switch (screenSize) {
      case ScreenSize.mobile:
        return _buildMobileLayout(context, menuStructure);
      case ScreenSize.tablet:
        return _buildTabletLayout(context, menuStructure);
      case ScreenSize.desktop:
        return _buildDesktopLayout(context, menuStructure);
    }
  }

  /// Mobile: Ein Screen zur Zeit mit BottomNavigationBar
  Widget _buildMobileLayout(BuildContext context, List<NavigationItem> menu) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RbsClone (Mobile)"),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(children: [Expanded(child: _buildMainContent())]),
      ),
      drawer: Drawer(
        child: HierarchicalNavigationMenu(
          items: menu,
          onItemSelected: (item) {
            if (item.children.isEmpty && item.onTap != null) {
              item.onTap!();
              setState(() => _mobileViewIndex = 1); // Zur Liste
            }
            Navigator.pop(context); // Menü schließen
          },
          selectedTitle: _selectedMenuItemTitle,
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, List<NavigationItem> menu) {
    return Scaffold(
      appBar: AppBar(title: Text("RbsClone (Tablet)")),
      body: Row(children: [Expanded(child: _buildMainContent())]),
      drawer: Drawer(
        child: HierarchicalNavigationMenu(
          items: menu,
          onItemSelected: (item) {
            if (item.children.isEmpty && item.onTap != null) {
              item.onTap!();
              setState(() => _mobileViewIndex = 1); // Zur Liste
            }
            Navigator.pop(context); // Menü schließen
          },
          selectedTitle: _selectedMenuItemTitle,
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<NavigationItem> menu) {
    return Scaffold(
      appBar: AppBar(title: Text("RbsClone (Desktop)")),
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: HierarchicalNavigationMenu(
              items: menu,
              onItemSelected: (item) {
                if (item.children.isEmpty && item.onTap != null) {
                  item.onTap!();
                }
              },
              selectedTitle: _selectedMenuItemTitle,
            ),
          ),
          const SizedBox(width: 16),
          // Hauptinhalt (rechts, nimmt rest des Platzes)
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }
}
