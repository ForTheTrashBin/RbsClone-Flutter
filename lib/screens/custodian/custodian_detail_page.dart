import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openapi/openapi.dart';

import 'custodian_form_dialog.dart';

class CustodianDataModule extends StatefulWidget {
  const CustodianDataModule(this.showBoth, {super.key});

  final bool showBoth;

  @override
  State<CustodianDataModule> createState() => _DataModuleState();
}

class _DataModuleState extends State<CustodianDataModule> {
  Custodian? _selectedItem;

  void onItemSelected(CustodianListItem? item) async {
    if (item != null) {
      if ((_selectedItem == null) || (_selectedItem!.id != item.id)) {
        final api = Openapi();

        Custodian? newItem;

        try {
          final response = await api
              .getCustodianApi()
              .getCustodianById(id: item.id)
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
        setState(() {
          _selectedItem = null;
        });
      }
    }
  }

  //----------------------------------------------------------------------------

  List<CountryListItem> _countries = [];

  void readCountries() async {
    final api = Openapi();

    List<CountryListItem> newList = [];

    try {
      final response = await api.getCountryApi().getCountries().timeout(
        const Duration(seconds: 10),
      );

      newList = response.data?.toList() ?? const <CountryListItem>[];
    } finally {
      setState(() {
        _countries = newList;
      });
    }
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    readCountries();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showBoth) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: _MasterList(onItemSelected, widget.showBoth),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: _selectedItem == null
                ? const Center(child: Text("Wähle einen Eintrag aus!"))
                : CustodianEditorPanel(
                    custodian: _selectedItem!,
                    countries: _countries,
                    onSaved: () async {},
                    onDelete: () async {},
                  ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: _MasterList(onItemSelected, widget.showBoth)),
        ],
      );
    }
  }
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

class _MasterList extends StatefulWidget {
  final ValueChanged<CustodianListItem?> onItemSelected;

  final bool showBoth;

  const _MasterList(this.onItemSelected, this.showBoth);

  @override
  State<_MasterList> createState() => _MasterListState();
}

class _MasterListState extends State<_MasterList> {
  CustodianListItem? _selectedItem;

  List<CustodianListItem> _entriesAll = [];
  List<CustodianListItem> _entriesFiltered = [];

  late Future<List<CustodianListItem>> _dbFuture;

  Future<List<CustodianListItem>> fetchCustodians() async {
    final responseFuture = Openapi().getCustodianApi().getCustodians().timeout(
      const Duration(seconds: 10),
    );

    final minWaitFuture = Future.delayed(Duration(milliseconds: 600));

    final waitGroup = await Future.wait([responseFuture, minWaitFuture]);

    final response = waitGroup[0];

    return response.data?.toList() ?? const <CustodianListItem>[];
  }

  void _onRefresh() {
    setState(() {
      _entriesAll = [];
      _entriesFiltered = [];

      _selectedItem = null;

      _searchController.clear();

      widget.onItemSelected(null);

      _dbFuture = fetchCustodians();
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
            if (_entriesAll.isEmpty) {
              _entriesAll = snapshot.data!;
              _entriesFiltered = _entriesAll;
            }

            //------------------------------------------------------------------

            if (_entriesFiltered.isNotEmpty) {
              if (_selectedItem != null) {
                CustodianListItem? foundItem = _entriesFiltered.where((entry) {
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
                        const SizedBox(width: 6),
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
                  // List of items or message, if list is empty
                  //------------------------------------------------------------
                  Expanded(
                    child: ClipRect(
                      child: _entriesFiltered.isEmpty
                          ? const Center(
                              child: Text("Keine Lagerstellen vorhanden."),
                            )
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
                                  trailing: !widget.showBoth
                                      ? const Icon(Icons.chevron_right)
                                      : null,
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
                      : const Center(child: Text('Bitte Datensatz auswählen.')),
                  /*
                      : CustodianEditorPanel(
                          key: ValueKey(selectedCustodian!.id),
                          custodian: selectedCustodian!,
                          countries: countries,
                          onSaved: onRefresh,
                          onDelete: () =>
                              onDeleteCustodian(selectedCustodian!.id),
                        ), */
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

  final Custodian custodian;
  final List<CountryListItem> countries;
  final Future<void> Function() onSaved;
  final Future<void> Function() onDelete;

  @override
  State<CustodianEditorPanel> createState() => _CustodianEditorPanelState();
}

class _CustodianEditorPanelState extends State<CustodianEditorPanel> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _shortcodeController;
  late final TextEditingController _nameController;
  late final TextEditingController _flagsController;
  late final TextEditingController _depotNoController;

  late String _selectedCountryId;

  bool _saving = false;

  void _syncControllers() {
    final custodian = widget.custodian;

    _shortcodeController.text = custodian.shortcode;
    _nameController.text = custodian.name;
    _flagsController.text = custodian.flags.toString();
    _depotNoController.text = custodian.depotno.toString();

    _selectedCountryId = custodian.idcountry;
  }

  @override
  void initState() {
    super.initState();
    _shortcodeController = TextEditingController(
      text: widget.custodian.shortcode,
    );
    _nameController = TextEditingController(text: widget.custodian.name);
    _flagsController = TextEditingController(
      text: widget.custodian.flags.toString(),
    );
    _depotNoController = TextEditingController(
      text: widget.custodian.depotno.toString(),
    );
    _selectedCountryId = widget.custodian.idcountry;
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
    _shortcodeController.dispose();
    _nameController.dispose();
    _flagsController.dispose();
    _depotNoController.dispose();
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
          ..shortcode = _shortcodeController.text.trim().toUpperCase()
          ..name = _nameController.text.trim()
          ..flags = int.tryParse(_flagsController.text) ?? 0
          ..depotno = _depotNoController.text.trim()
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
            const SizedBox(height: 12),
            TextFormField(
              maxLength: 5,
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
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCountryId,
              decoration: const InputDecoration(labelText: 'Land'),
              items: widget.countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country.id,
                  child: Text('${country.shortcode} (${country.name})'),
                );
              }).toList(),
              onChanged: (value) =>
                  setState(() => _selectedCountryId = value ?? ''),
              validator: (value) => value == null || value.isEmpty
                  ? 'Bitte ein Land auswählen'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              maxLength: 10,
              controller: _depotNoController,
              decoration: const InputDecoration(labelText: 'Depotnummer'),
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
