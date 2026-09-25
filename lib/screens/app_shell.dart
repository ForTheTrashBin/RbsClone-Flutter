import 'package:flutter/material.dart';
import 'package:rbsclone_flutter/widgets/hierarchical_navigation_menu.dart';
import 'package:rbsclone_flutter/widgets/placeholder_page.dart';
import 'package:rbsclone_flutter/widgets/adaptive_layout.dart';

import 'master/country/country.dart';
import 'master/custodian/custodian.dart';
import 'master/exchange/exchange.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  // late final CountryRepository _countryRepository = CountryRepository();
  // late final CustodianRepository _custodianRepository = CustodianRepository();
  // late final ExchangeRepository _exchangeRepository = ExchangeRepository();

  /// Welcher Menü-Item ist aktuell ausgewählt?

  NavigationId _navigationId = NavigationId.welcome;

  String _caption = "Bitte wählen Sie ein Funktion aus!";
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
  /// Gibt den aktuellen Hauptinhalt basierend auf der Auswahl zurück
  Widget _buildMainContent(bool showBoth) {
    switch (_navigationId) {
      case NavigationId.welcome:
        return const PlaceholderPage(title: 'Willkommen!');

      case NavigationId.country:
        return CountryDataModule(showBoth);
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
      case NavigationId.custodian:
        return CustodianDataModule(showBoth);
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
      case NavigationId.exchange:
        return ExchangeDataModule(showBoth);
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

    switch (screenSize) {
      case ScreenSize.mobile:
        return _buildMobileLayout(context);
      case ScreenSize.tablet:
        return _buildTabletLayout(context);
      case ScreenSize.desktop:
        return _buildDesktopLayout(context);
    }
  }

  //----------------------------------------------------------------------------

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("RbsClone"),
            Opacity(
              opacity: 0.7,
              child: Text(
                _caption,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize:
                      Theme.of(context).textTheme.titleLarge!.fontSize! * 0.7,
                ),
              ),
            ),
          ],
        ),
        // scrolledUnderElevation: 0,
        // backgroundColor: Colors.transparent,
        // elevation: 0,
      ),
      drawer: Drawer(
        child: NavigationMenu(
          onItemSelected: (item) {
            if (item.children.isEmpty) {
              setState(() {
                _navigationId = item.navigationId;
                _caption = item.caption;
              });
            }
            Navigator.pop(context); // Menü schließen
          },
          selectedNavigationId: _navigationId,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(children: [Expanded(child: _buildMainContent(false))]),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("RbsClone"),
            Opacity(
              opacity: 0.7,
              child: Text(
                _caption,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize:
                      Theme.of(context).textTheme.titleLarge!.fontSize! * 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: NavigationMenu(
          onItemSelected: (item) {
            if (item.children.isEmpty) {
              setState(() {
                _navigationId = item.navigationId;
                _caption = item.caption;
              });
            }
            Navigator.pop(context); // Menü schließen
          },
          selectedNavigationId: _navigationId,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(children: [Expanded(child: _buildMainContent(true))]),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("RbsClone"),
            Opacity(
              opacity: 0.7,
              child: Text(
                _caption,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize:
                      Theme.of(context).textTheme.titleLarge!.fontSize! * 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 250,
                child: NavigationMenu(
                  onItemSelected: (item) {
                    if (item.children.isEmpty) {
                      setState(() {
                        _navigationId = item.navigationId;
                        _caption = item.caption;
                      });
                    }
                  },
                  selectedNavigationId: _navigationId,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildMainContent(true)),
            ],
          ),
        ),
      ),
    );
  }
}
