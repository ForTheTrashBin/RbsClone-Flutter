import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openapi/openapi.dart';

import 'country_form_dialog.dart';

class CountryDataModule extends StatefulWidget {
  const CountryDataModule({super.key});

  @override
  State<CountryDataModule> createState() => _DataModuleState();
}

class _DataModuleState extends State<CountryDataModule> {
  Country? _selectedItem;

  void onItemSelected(CountryListItem? item) async {
    if (item != null) {
      if ((_selectedItem == null) || (_selectedItem!.id != item.id)) {
        print("An item was selected: ${item.id}");

        final api = Openapi();

        Country? newItem;

        try {
          final response = await api
              .getCountryApi()
              .getCountryById(id: item.id)
              .timeout(const Duration(seconds: 10));

          newItem = response.data;
        } finally {
          setState(() {
            _selectedItem = newItem;
          });
        }
      }
    } else {
      if (_selectedItem != null) {
        print("An item was deselected");

        setState(() {
          _selectedItem = null;
        });
      }
    }
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth >= 768) {
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _MasterList(
                    // selectItem: provider.selectedItem,
                    onItemSelected: onItemSelected,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  flex: 3,
                  child: _selectedItem == null
                      ? const Center(child: Text("Wähle einen Eintrag aus!"))
                      : CountryEditorPanel(
                          country: _selectedItem!,
                          onSaved: () async {},
                          onDelete: () async {},
                        ),
                  /*
                      DetailView(
                      item: selectedItem,
                      isDirty: isDirty
                      onchanged: (dirty) => ????
                      )
                      */
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text("SmallScreen"));
        }
      }),
    );
  }
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

class _MasterList extends StatefulWidget {
  final ValueChanged<CountryListItem?> onItemSelected;

  const _MasterList({super.key, required this.onItemSelected});

  @override
  State<_MasterList> createState() => _MasterListState();
}

class _MasterListState extends State<_MasterList> {
  CountryListItem? _selectedItem;

  List<CountryListItem> _entriesAll = [];
  List<CountryListItem> _entriesFiltered = [];

  late Future<List<CountryListItem>> _dbFuture;

  Future<List<CountryListItem>> fetchCountries() async {
    final responseFuture = Openapi().getCountryApi().getCountries().timeout(
      const Duration(seconds: 10),
    );

    final minWaitFuture = Future.delayed(Duration(milliseconds: 600));

    final waitGroup = await Future.wait([responseFuture, minWaitFuture]);

    final response = waitGroup[0];

    return response.data?.toList() ?? const <CountryListItem>[];
  }

  void _onRefresh() {
    setState(() {
      _entriesAll = [];
      _entriesFiltered = [];

      _selectedItem = null;

      widget.onItemSelected(null);

      _dbFuture = fetchCountries();
    });
  }

  //----------------------------------------------------------------------------

  final TextEditingController _searchController = TextEditingController();

  void _filterListe(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _entriesFiltered = _entriesAll;
      } else {
        _entriesFiltered = _entriesAll.where((entry) {
          String searchTextLower = searchText.toLowerCase();

          return entry.shortcode.toLowerCase().contains(searchTextLower) ||
              entry.name.toLowerCase().contains(searchTextLower);
        }).toList();
      }
    });
  }

  //----------------------------------------------------------------------------

  void onNew() {}

  //----------------------------------------------------------------------------

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
            if (_entriesAll.isEmpty) {
              _entriesAll = snapshot.data!;
              _entriesFiltered = _entriesAll;
            }

            //------------------------------------------------------------------

            if (_entriesFiltered.isNotEmpty) {
              if (_selectedItem != null) {
                CountryListItem? foundItem = _entriesFiltered.where((entry) {
                  return entry.id == _selectedItem!.id;
                }).firstOrNull;

                if (foundItem == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedItem = _entriesFiltered[0];
                    });

                    widget.onItemSelected(_entriesFiltered[0]);
                  });
                }
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _selectedItem = _entriesFiltered[0];
                  });

                  widget.onItemSelected(_entriesFiltered[0]);
                });
              }
            } else {
              if (_selectedItem != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _selectedItem = null;
                  });

                  widget.onItemSelected(null);
                });
              }
            }

            //------------------------------------------------------------------

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
                            "${_entriesFiltered.length}",
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
                      child: _entriesFiltered.isEmpty
                          ? const Center(child: Text("Keine Länder vorhanden."))
                          : ListView.separated(
                              itemCount: _entriesFiltered.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final listItem = _entriesFiltered[index];
                                final isSelected =
                                    _selectedItem?.id == listItem.id;
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      listItem.shortcode
                                          .substring(0, 1)
                                          .toUpperCase(),
                                    ),
                                  ),
                                  title: Text(listItem.shortcode),
                                  subtitle: Text(listItem.name),
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
                                      _selectedItem = listItem;
                                    });

                                    widget.onItemSelected(listItem);
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

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

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
                      : const Center(child: Text('Bitte Datensatz auswählen.')),
                  /*
                      : CountryEditorPanel(
                          key: ValueKey(selectedCountry!.id),
                          country: selectedCountry!,
                          onSaved: onRefresh,
                          onDelete: () => onDeleteCountry(selectedCountry!.id),
                        ),*/
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

  final Country country;

  final Future<void> Function() onSaved;
  final Future<void> Function() onDelete;

  @override
  State<CountryEditorPanel> createState() => _CountryEditorPanelState();
}

class _CountryEditorPanelState extends State<CountryEditorPanel> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _shortcodeController;
  late final TextEditingController _nameController;
  late final TextEditingController _flagsController;
  late final TextEditingController _ibanLengthController;
  late final TextEditingController _riskTypeController;
  bool _saving = false;

  void _syncControllers() {
    final country = widget.country;
    _shortcodeController.text = country.shortcode;
    _nameController.text = country.name;
    _flagsController.text = country.flags.toString();
    _ibanLengthController.text = country.ibanlenth?.toString() ?? '';
    _riskTypeController.text = country.risktype.toString();
  }

  @override
  void initState() {
    super.initState();
    final country = widget.country;
    _shortcodeController = TextEditingController(text: country.shortcode);
    _nameController = TextEditingController(text: country.name);
    _flagsController = TextEditingController(text: country.flags.toString());
    _ibanLengthController = TextEditingController(
      text: country.ibanlenth?.toString() ?? '',
    );
    _riskTypeController = TextEditingController(
      text: country.risktype.toString(),
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
    _shortcodeController.dispose();
    _nameController.dispose();
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
          ..shortcode = _shortcodeController.text.trim().toUpperCase()
          ..name = _nameController.text.trim()
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
              maxLength: 2,
              controller: _shortcodeController,
              decoration: const InputDecoration(labelText: 'Kürzel'),
              inputFormatters: [
                TextInputFormatter.withFunction((_, newValue) {
                  return newValue.copyWith(text: newValue.text.toUpperCase());
                }),
              ],
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Pflichtfeld'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              maxLength: 30,
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
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
