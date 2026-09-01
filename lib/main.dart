import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

void main() {
  runApp(const RbsCloneApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const RbsCloneApp();
  }
}

class RbsCloneApp extends StatelessWidget {
  const RbsCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RbsClone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainMenuPage(),
    );
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MenuItem(
        title: 'Stammdaten',
        subtitle: 'Country, Custodian, Exchange',
        icon: Icons.storage,
        page: const MasterDataMenuPage(),
      ),
      _MenuItem(
        title: 'Aufträge',
        subtitle: 'Bald verfügbar',
        icon: Icons.assignment,
        page: const PlaceholderPage(title: 'Aufträge'),
      ),
      _MenuItem(
        title: 'Berichte',
        subtitle: 'Bald verfügbar',
        icon: Icons.bar_chart,
        page: const PlaceholderPage(title: 'Berichte'),
      ),
      _MenuItem(
        title: 'Lager',
        subtitle: 'Bald verfügbar',
        icon: Icons.inventory_2,
        page: const PlaceholderPage(title: 'Lager'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('RBS Clone')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.4,
          children: [for (final item in menuItems) _MenuCard(item: item)],
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.item});

  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => item.page));
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                size: 38,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(item.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                item.subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MasterDataMenuPage extends StatelessWidget {
  const MasterDataMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [
      _MasterMenuItem(
        title: 'Country',
        subtitle: 'Länderstammdaten',
        icon: Icons.flag,
        page: const CountryPage(),
      ),
      _MasterMenuItem(
        title: 'Custodian',
        subtitle: 'Dummy',
        icon: Icons.person,
        page: const PlaceholderPage(title: 'Custodian'),
      ),
      _MasterMenuItem(
        title: 'Exchange',
        subtitle: 'Dummy',
        icon: Icons.currency_exchange,
        page: const PlaceholderPage(title: 'Exchange'),
      ),
      _MasterMenuItem(
        title: 'Custodian2Exchange',
        subtitle: 'Dummy',
        icon: Icons.link,
        page: const PlaceholderPage(title: 'Custodian2Exchange'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Stammdaten')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.4,
          children: [for (final entry in entries) _MasterMenuCard(item: entry)],
        ),
      ),
    );
  }
}

class _MasterMenuItem {
  const _MasterMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;
}

class _MasterMenuCard extends StatelessWidget {
  const _MasterMenuCard({required this.item});

  final _MasterMenuItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => item.page));
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(item.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                item.subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64),
            const SizedBox(height: 16),
            Text(
              '$title ist noch Dummy.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Diese Funktion wird später implementiert.'),
          ],
        ),
      ),
    );
  }
}

class CountryPage extends StatefulWidget {
  const CountryPage({super.key});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  final CountryRepository _repository = CountryRepository();
  bool _loading = true;
  String? _error;
  List<Country> _countries = const [];

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final countries = await _repository.fetchCountries();
      if (!mounted) return;
      setState(() {
        _countries = countries;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

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
      await _repository.deleteCountry(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Land wurde gelöscht.')));
      await _loadCountries();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler beim Löschen: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country'),
        actions: [
          IconButton(
            onPressed: _loadCountries,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => const CountryFormDialog(),
          );
          if (result == true) {
            await _loadCountries();
          }
        },
        label: const Text('Neu'),
        icon: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Fehler beim Laden',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(_error!),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _loadCountries,
                      child: const Text('Erneut versuchen'),
                    ),
                  ],
                ),
              ),
            )
          : _countries.isEmpty
          ? const Center(child: Text('Keine Länder vorhanden.'))
          : ListView.separated(
              itemCount: _countries.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final country = _countries[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      country.shortcode.substring(0, 1).toUpperCase(),
                    ),
                  ),
                  title: Text(country.name),
                  subtitle: Text(
                    '${country.shortcode} • flags=${country.flags} • risk=${country.risktype}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Bearbeiten',
                        onPressed: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (_) => CountryFormDialog(country: country),
                          );
                          if (result == true) {
                            await _loadCountries();
                          }
                        },
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Löschen',
                        onPressed: () => _deleteCountry(country.id),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class CountryRepository {
  CountryRepository();

  final Openapi _api = Openapi();

  Future<List<Country>> fetchCountries() async {
    final response = await _api.getCountryApi().getCountries();
    return response.data?.toList() ?? const <Country>[];
  }

  Future<void> createCountry(CountryNoPK country) async {
    await _api.getCountryApi().createCountry(countryNoPK: country);
  }

  Future<void> updateCountry(String id, CountryNoPK country) async {
    await _api.getCountryApi().updateCountry(id: id, countryNoPK: country);
  }

  Future<void> deleteCountry(String id) async {
    await _api.getCountryApi().deleteCountry(id: id);
  }
}

class CountryFormDialog extends StatefulWidget {
  const CountryFormDialog({this.country, super.key});

  final Country? country;

  @override
  State<CountryFormDialog> createState() => _CountryFormDialogState();
}

class _CountryFormDialogState extends State<CountryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shortcodeController = TextEditingController();
  final _flagsController = TextEditingController();
  final _ibanLengthController = TextEditingController();
  final _riskTypeController = TextEditingController();

  late final bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.country != null;
    final country = widget.country;
    if (country != null) {
      _nameController.text = country.name;
      _shortcodeController.text = country.shortcode;
      _flagsController.text = country.flags.toString();
      _ibanLengthController.text = country.ibanlenth?.toString() ?? '';
      _riskTypeController.text = country.risktype.toString();
    } else {
      _flagsController.text = '0';
      _riskTypeController.text = '0';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortcodeController.dispose();
    _flagsController.dispose();
    _ibanLengthController.dispose();
    _riskTypeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final repository = CountryRepository();
    final payload = CountryNoPK(
      (b) => b
        ..name = _nameController.text.trim()
        ..shortcode = _shortcodeController.text.trim().toUpperCase()
        ..flags = int.tryParse(_flagsController.text) ?? 0
        ..risktype = int.tryParse(_riskTypeController.text) ?? 0
        ..ibanlenth = int.tryParse(
          _ibanLengthController.text.isEmpty ? '0' : _ibanLengthController.text,
        ),
    );

    try {
      if (_isEditMode) {
        await repository.updateCountry(widget.country!.id, payload);
      } else {
        await repository.createCountry(payload);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Speichern fehlgeschlagen: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Land bearbeiten' : 'Land anlegen'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Pflichtfeld'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _shortcodeController,
                  decoration: const InputDecoration(labelText: 'Shortcode'),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Pflichtfeld'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _flagsController,
                  decoration: const InputDecoration(labelText: 'Flags'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Pflichtfeld';
                    }
                    return int.tryParse(value) == null
                        ? 'Zahl erforderlich'
                        : null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ibanLengthController,
                  decoration: const InputDecoration(
                    labelText: 'IBAN Länge (optional)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _riskTypeController,
                  decoration: const InputDecoration(labelText: 'Risk Type'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Pflichtfeld';
                    }
                    return int.tryParse(value) == null
                        ? 'Zahl erforderlich'
                        : null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(_isEditMode ? 'Speichern' : 'Erstellen'),
        ),
      ],
    );
  }
}
