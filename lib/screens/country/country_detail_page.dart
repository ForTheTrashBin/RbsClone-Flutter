import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

import 'country_form_dialog.dart';

class CountryDetailPage extends StatelessWidget {
  const CountryDetailPage({
    required this.country,
    required this.onRefresh,
    required this.onDelete,
    super.key,
  });

  final Country country;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (_) => CountryFormDialog(country: country),
              );
              if (result == true) {
                await onRefresh();
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: CountryDetailPanel(
          country: country,
          onRefresh: onRefresh,
          onEdit: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => CountryFormDialog(country: country),
            );
            if (result == true) {
              await onRefresh();
              if (context.mounted) Navigator.of(context).pop();
            }
          },
          onDelete: () => onDelete(country.id),
        ),
      ),
    );
  }
}

class CountryDetailPanel extends StatelessWidget {
  const CountryDetailPanel({
    required this.country,
    required this.onRefresh,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Country country;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _DetailRow(label: 'ID', value: country.id),
      _DetailRow(label: 'Shortcode', value: country.shortcode),
      _DetailRow(label: 'Name', value: country.name),
      _DetailRow(label: 'Flags', value: country.flags.toString()),
      _DetailRow(
        label: 'IBAN Länge',
        value: country.ibanlenth?.toString() ?? '—',
      ),
      _DetailRow(label: 'Risk Type', value: country.risktype.toString()),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.flag, size: 28),
            const SizedBox(width: 12),
            Text(
              country.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              itemCount: rows.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) => rows[index],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            FilledButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Bearbeiten'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () async {
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
                if (confirmed == true) {
                  await onDelete();
                  await onRefresh();
                }
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Löschen'),
            ),
          ],
        ),
      ],
    );
  }
}

class CountryMasterList extends StatefulWidget {
  final ValueChanged<CountryListItem> onItemSelected;

  const CountryMasterList({super.key, required this.onItemSelected});

  @override
  State<CountryMasterList> createState() => _CountryMasterListState();
}

class _CountryMasterListState extends State<CountryMasterList> {
  late Future<List<CountryListItem>> _dbFuture;

  List<CountryListItem> _allEntries = [];
  List<CountryListItem> _filteredEntries = [];

  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = -1;

  Future<List<CountryListItem>> fetchCountries() async {
    final api = Openapi();

    final responseFuture = api.getCountryApi().getCountries().timeout(
      const Duration(seconds: 10),
    );

    final minWaitFuture = Future.delayed(Duration(milliseconds: 600));

    final waitGroup = await Future.wait([responseFuture, minWaitFuture]);

    final response = waitGroup[0];

    return response.data?.toList() ?? const <CountryListItem>[];
  }

  void _onRefresh() {
    setState(() {
      _allEntries = [];
      _filteredEntries = [];

      _dbFuture = fetchCountries();
    });
  }

  void onNew() {}

  void _filterListe(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _filteredEntries = _allEntries;
      } else {
        _filteredEntries = _allEntries.where((entry) {
          String searchTextLower = searchText.toLowerCase();

          return entry.shortcode.toLowerCase().contains(searchTextLower) ||
              entry.name.toLowerCase().contains(searchTextLower);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _dbFuture = fetchCountries();
  }

  // TODO: Premium-UX, Paket: shimmer, um das Flackern beim Update zu vermeiden

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onNew,
        label: const Text("Neu"),
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<CountryListItem>>(
        future: _dbFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            if (_allEntries.isEmpty) {
              _allEntries = snapshot.data!;
              _filteredEntries = _allEntries;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  //------------------------------------------------------------
                  // Title & refresh
                  //------------------------------------------------------------
                  Container(
                    height: 56.0,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Länder",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                          onPressed: _onRefresh,
                        ),
                      ],
                    ),
                  ),
                  //------------------------------------------------------------
                  // Count & search
                  //------------------------------------------------------------
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 12.0,
                      bottom: 12.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${_filteredEntries.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              // color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterListe,
                            decoration: InputDecoration(
                              hintText: "Suchen...",
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear, size: 20),
                                      onPressed: () {
                                        _searchController.clear();
                                        _filterListe("");
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //------------------------------------------------------------
                  // List of item or message, if list is empty
                  //------------------------------------------------------------
                  Expanded(
                    child: ClipRect(
                      child: _filteredEntries.isEmpty
                          ? const Center(child: Text("Keine Länder vorhanden."))
                          : ListView.separated(
                              itemCount: _filteredEntries.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final countryListItem = _filteredEntries[index];
                                final isSelected = _selectedIndex == index;
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      countryListItem.shortcode
                                          .substring(0, 1)
                                          .toUpperCase(),
                                    ),
                                  ),
                                  title: Text(countryListItem.shortcode),
                                  subtitle: Text(countryListItem.name),
                                  selected: isSelected,
                                  selectedTileColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                      .withValues(alpha: 0.55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });

                                    widget.onItemSelected(countryListItem);
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CountryMasterPanel extends StatelessWidget {
  const CountryMasterPanel({
    required this.countries,
    required this.loading,
    required this.error,
    required this.selectedCountry,
    required this.onSelectCountry,
    required this.onRefresh,
    required this.onNewCountry,
    required this.onEditCountry,
    required this.onDeleteCountry,
    super.key,
  });

  final List<CountryListItem> countries;
  final bool loading;
  final String? error;
  final CountryListItem? selectedCountry;
  final ValueChanged<CountryListItem> onSelectCountry;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onNewCountry;
  final Future<void> Function(Country country) onEditCountry;
  final Future<void> Function(String id) onDeleteCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country'),
        actions: [
          IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => const CountryFormDialog(),
          );
          if (result == true) {
            await onRefresh();
          }
        },
        label: const Text('Neu'),
        icon: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : countries.isEmpty
          ? const Center(child: Text('Keine Länder vorhanden.'))
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.separated(
                    itemCount: countries.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final country = countries[index];
                      final isSelected = selectedCountry?.id == country.id;
                      return ListTile(
                        selected: isSelected,
                        selectedTileColor: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                                  .withOpacity(0.55)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: CircleAvatar(
                          child: Text(
                            country.shortcode.substring(0, 1).toUpperCase(),
                          ),
                        ),
                        title: Text(country.shortcode),
                        subtitle: Text(country.name),
                        onTap: () => onSelectCountry(country),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: selectedCountry == null
                      ? const Center(child: Text('Bitte Datensatz auswählen.'))
                      : CountryEditorPanel(
                          key: ValueKey(selectedCountry!.id),
                          country: selectedCountry!,
                          onSaved: onRefresh,
                          onDelete: () => onDeleteCountry(selectedCountry!.id),
                        ),
                ),
              ],
            ),
    );
  }
}

class CountryEditorPanel extends StatefulWidget {
  const CountryEditorPanel({
    required this.country,
    required this.onSaved,
    required this.onDelete,
    super.key,
  });

  final CountryListItem country;
  final Future<void> Function() onSaved;
  final Future<void> Function() onDelete;

  @override
  State<CountryEditorPanel> createState() => _CountryEditorPanelState();
}

class _CountryEditorPanelState extends State<CountryEditorPanel> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _shortcodeController;
  late final TextEditingController _flagsController;
  late final TextEditingController _ibanLengthController;
  late final TextEditingController _riskTypeController;
  bool _saving = false;

  void _syncControllers() {
    final country = widget.country;
    _nameController.text = country.name;
    _shortcodeController.text = country.shortcode;
    // _flagsController.text = country.flags.toString();
    // _ibanLengthController.text = country.ibanlenth?.toString() ?? '';
    // _riskTypeController.text = country.risktype.toString();
  }

  @override
  void initState() {
    super.initState();
    final country = widget.country;
    _nameController = TextEditingController(text: country.name);
    _shortcodeController = TextEditingController(text: country.shortcode);
    _flagsController = TextEditingController(
      text: "Dummy",
    ); // country.flags.toString());
    _ibanLengthController = TextEditingController(
      text: "Dummy", // country.ibanlenth?.toString() ?? '',
    );
    _riskTypeController = TextEditingController(
      text: "Dummy", // country.risktype.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant CountryEditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.country != widget.country) {
      _syncControllers();
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final payload = CountryNoPK(
        (b) => b
          ..name = _nameController.text.trim()
          ..shortcode = _shortcodeController.text.trim().toUpperCase()
          ..flags = int.tryParse(_flagsController.text) ?? 0
          ..risktype = int.tryParse(_riskTypeController.text) ?? 0
          ..ibanlenth = int.tryParse(
            _ibanLengthController.text.isEmpty
                ? '0'
                : _ibanLengthController.text,
          ),
      );

      await Openapi().getCountryApi().updateCountry(
        id: widget.country.id,
        countryNoPK: payload,
      );
      await widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Speichern fehlgeschlagen: $e')));
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _delete() async {
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

    await widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              'Datensatz bearbeiten',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
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
                if (value == null || value.trim().isEmpty) return 'Pflichtfeld';
                return int.tryParse(value) == null ? 'Zahl erforderlich' : null;
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
                if (value == null || value.trim().isEmpty) return 'Pflichtfeld';
                return int.tryParse(value) == null ? 'Zahl erforderlich' : null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_saving ? 'Speichert...' : 'Speichern'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Löschen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
