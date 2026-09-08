import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

import 'custodian_form_dialog.dart';

class CustodianDetailPage extends StatelessWidget {
  const CustodianDetailPage({
    required this.custodian,
    required this.countries,
    required this.onRefresh,
    required this.onDelete,
    super.key,
  });

  final Custodian custodian;
  final List<CountryListItem> countries;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    final country = countries.firstWhere(
      (entry) => entry.id == custodian.idcountry,
      orElse: () => CountryListItem(
        (b) => b
          ..id = custodian.idcountry
          ..name = 'Unbekannt'
          ..shortcode = '—',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(custodian.name),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (_) => CustodianFormDialog(
                  countries: countries,
                  custodian: custodian,
                ),
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
        child: CustodianDetailPanel(
          custodian: custodian,
          country: country,
          onRefresh: onRefresh,
          onEdit: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => CustodianFormDialog(
                countries: countries,
                custodian: custodian,
              ),
            );
            if (result == true) {
              await onRefresh();
              if (context.mounted) Navigator.of(context).pop();
            }
          },
          onDelete: () => onDelete(custodian.id),
        ),
      ),
    );
  }
}

class CustodianDetailPanel extends StatelessWidget {
  const CustodianDetailPanel({
    required this.custodian,
    required this.country,
    required this.onRefresh,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Custodian custodian;
  final CountryListItem country;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _DetailRow(label: 'ID', value: custodian.id),
      _DetailRow(label: 'Shortcode', value: custodian.shortcode),
      _DetailRow(label: 'Name', value: custodian.name),
      _DetailRow(
        label: 'Land',
        value: '${country.name} (${country.shortcode})',
      ),
      _DetailRow(label: 'Depotnummer', value: custodian.depotno.toString()),
      _DetailRow(label: 'Flags', value: custodian.flags.toString()),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person, size: 28),
            const SizedBox(width: 12),
            Text(
              custodian.name,
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

class CustodianMasterList extends StatefulWidget {
  final ValueChanged<CustodianListItem> onItemSelected;

  const CustodianMasterList({super.key, required this.onItemSelected});

  @override
  State<CustodianMasterList> createState() => _CustodianMasterListState();
}

class _CustodianMasterListState extends State<CustodianMasterList> {
  late Future<List<CustodianListItem>> _dbFuture;

  List<CustodianListItem> _allEntries = [];
  List<CustodianListItem> _filteredEntries = [];

  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = -1;

  Future<List<CustodianListItem>> fetchCustodians() async {
    final api = Openapi();

    final results = await Future.wait([
      api.getCustodianApi().getCustodians().timeout(
        const Duration(seconds: 10),
      ),
      Future.delayed(Duration(milliseconds: 600)),
    ]);

    final response = results[0];
    /*
    final responses = await api.getCustodianApi().getCustodians().timeout(
      const Duration(seconds: 10),
    );
*/
    return response.data?.toList() ?? const <CustodianListItem>[];
  }

  void _onRefresh() {
    setState(() {
      _allEntries = [];
      _filteredEntries = [];

      _dbFuture = fetchCustodians();
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

    _dbFuture = fetchCustodians();
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
      body: FutureBuilder<List<CustodianListItem>>(
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
                            "Lagerstellen",
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
                          ? const Center(
                              child: Text("Keine Lagerstellen vorhanden."),
                            )
                          : ListView.separated(
                              itemCount: _filteredEntries.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final custodianListItem =
                                    _filteredEntries[index];
                                final isSelected = _selectedIndex == index;
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      custodianListItem.shortcode
                                          .substring(0, 1)
                                          .toUpperCase(),
                                    ),
                                  ),
                                  title: Text(custodianListItem.shortcode),
                                  subtitle: Text(custodianListItem.name),
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

                                    widget.onItemSelected(custodianListItem);
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

class CustodianMasterPanel extends StatelessWidget {
  const CustodianMasterPanel({
    required this.custodians,
    required this.countries,
    required this.loading,
    required this.error,
    required this.selectedCustodian,
    required this.onSelectCustodian,
    required this.onRefresh,
    required this.onNewCustodian,
    required this.onEditCustodian,
    required this.onDeleteCustodian,
    super.key,
  });

  final List<CustodianListItem> custodians;
  final List<CountryListItem> countries;
  final bool loading;
  final String? error;
  final CustodianListItem? selectedCustodian;
  final ValueChanged<CustodianListItem> onSelectCustodian;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onNewCustodian;
  final Future<void> Function(Custodian custodian) onEditCustodian;
  final Future<void> Function(String id) onDeleteCustodian;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lagerstellen'),
        actions: [
          IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => CustodianFormDialog(countries: countries),
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
          : custodians.isEmpty
          ? const Center(child: Text('Keine Lagerstellen vorhanden.'))
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.separated(
                    itemCount: custodians.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final custodian = custodians[index];
                      final isSelected = selectedCustodian?.id == custodian.id;
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
                            custodian.shortcode.substring(0, 1).toUpperCase(),
                          ),
                        ),
                        title: Text(custodian.shortcode),
                        subtitle: Text(custodian.name),
                        onTap: () => onSelectCustodian(custodian),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: selectedCustodian == null
                      ? const Center(child: Text('Bitte Datensatz auswählen.'))
                      : CustodianEditorPanel(
                          key: ValueKey(selectedCustodian!.id),
                          custodian: selectedCustodian!,
                          countries: countries,
                          onSaved: onRefresh,
                          onDelete: () =>
                              onDeleteCustodian(selectedCustodian!.id),
                        ),
                ),
              ],
            ),
    );
  }
}

class CustodianEditorPanel extends StatefulWidget {
  const CustodianEditorPanel({
    required this.custodian,
    required this.countries,
    required this.onSaved,
    required this.onDelete,
    super.key,
  });

  final CustodianListItem custodian;
  final List<CountryListItem> countries;
  final Future<void> Function() onSaved;
  final Future<void> Function() onDelete;

  @override
  State<CustodianEditorPanel> createState() => _CustodianEditorPanelState();
}

class _CustodianEditorPanelState extends State<CustodianEditorPanel> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _shortcodeController;
  late final TextEditingController _depotNoController;
  late final TextEditingController _flagsController;
  late String _selectedCountryId;
  bool _saving = false;

  void _syncControllers() {
    final custodian = widget.custodian;
    _nameController.text = custodian.name;
    _shortcodeController.text = custodian.shortcode;
    // _depotNoController.text = custodian.depotno.toString();
    // _flagsController.text = custodian.flags.toString();
    // _selectedCountryId = custodian.idcountry;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.custodian.name);
    _shortcodeController = TextEditingController(
      text: widget.custodian.shortcode,
    );
    _depotNoController = TextEditingController(
      text: "Dummy", // widget.custodian.depotno.toString(),
    );
    _flagsController = TextEditingController(
      text: "Dummy", // widget.custodian.flags.toString(),
    );
    _selectedCountryId = "Dummy"; // widget.custodian.idcountry;
  }

  @override
  void didUpdateWidget(covariant CustodianEditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.custodian != widget.custodian) {
      _syncControllers();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortcodeController.dispose();
    _depotNoController.dispose();
    _flagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCountryId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte ein Land auswählen.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final payload = CustodianNoPK(
        (b) => b
          ..name = _nameController.text.trim()
          ..shortcode = _shortcodeController.text.trim().toUpperCase()
          ..depotno = _depotNoController.text.trim()
          ..flags = int.tryParse(_flagsController.text) ?? 0
          ..idcountry = _selectedCountryId,
      );

      await Openapi().getCustodianApi().updateCustodian(
        id: widget.custodian.id,
        custodianNoPK: payload,
      );
      await widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Speichern fehlgeschlagen: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
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
            Text('Dummy'),
            /*
            DropdownButtonFormField<String>(
              initialValue: _selectedCountryId,
              decoration: const InputDecoration(labelText: 'Land'),
              items: widget.countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country.id,
                  child: Text('${country.name} (${country.shortcode})'),
                );
              }).toList(),
              onChanged: (value) =>
                  setState(() => _selectedCountryId = value ?? ''),
              validator: (value) => value == null || value.isEmpty
                  ? 'Bitte ein Land auswählen'
                  : null,
            ),
            */
            const SizedBox(height: 12),
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
              controller: _depotNoController,
              decoration: const InputDecoration(labelText: 'Depotnummer'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Pflichtfeld';
                return int.tryParse(value) == null ? 'Zahl erforderlich' : null;
              },
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
