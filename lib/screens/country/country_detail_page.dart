import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openapi/openapi.dart';

class CountryDataModule extends StatefulWidget {
  const CountryDataModule(this.showBoth, {super.key});

  final bool showBoth;

  @override
  State<CountryDataModule> createState() => _DataModuleState();
}

class _DataModuleState extends State<CountryDataModule> {
  CountryListItem? _selectedListItem;

  void onItemSelected(CountryListItem? item) {
    if (item != null) {
      if ((_selectedListItem == null) || (_selectedListItem!.id != item.id)) {
        setState(() {
          _selectedListItem = item;
        });
      }
    } else {
      if (_selectedListItem != null) {
        setState(() {
          _selectedListItem = null;
        });
      }
    }
  }

  void onItemCreated(CountryListItem? item) {}

  void onItemSaved(CountryListItem? item) {}

  void onItemDeleted(CountryListItem? item) {}

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (widget.showBoth) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: _MasterList(
              showBoth: widget.showBoth,
              selectedListItem: _selectedListItem,
              itemSelectedCallback: onItemSelected,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: CountryEditorPanel(
              showBoth: widget.showBoth,
              listItem: _selectedListItem,
              itemCreatedCallback: onItemCreated,
              itemSavedCallback: onItemSaved,
              itemDeletedCallback: onItemDeleted,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _MasterList(
              showBoth: widget.showBoth,
              selectedListItem: _selectedListItem,
              itemSelectedCallback: (item) {
                onItemSelected(item);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CountryEditorPanel(
                        showBoth: widget.showBoth,
                        listItem: _selectedListItem,
                        itemCreatedCallback: onItemCreated,
                        itemSavedCallback: onItemSaved,
                        itemDeletedCallback: onItemDeleted,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

class _MasterList extends StatefulWidget {
  final bool showBoth;

  final CountryListItem? selectedListItem;

  final ValueChanged<CountryListItem?> itemSelectedCallback;

  const _MasterList({
    required this.showBoth,
    required this.selectedListItem,
    required this.itemSelectedCallback,
  });

  @override
  State<_MasterList> createState() => _MasterListState();
}

class _MasterListState extends State<_MasterList> {
  List<CountryListItem> _entriesAll = [];
  List<CountryListItem> _entriesFiltered = [];

  late Future<List<CountryListItem>> _dbFuture;

  Future<List<CountryListItem>> fetchCountries() async {
    final openapi = Openapi();

    openapi.dio.options.connectTimeout = const Duration(seconds: 10);
    openapi.dio.options.receiveTimeout = const Duration(seconds: 15);
    // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

    final responseFuture = openapi.getCountryApi().getCountries();

    final minWaitFuture = Future.delayed(Duration(milliseconds: 600));

    final waitGroup = await Future.wait([responseFuture, minWaitFuture]);

    final response = waitGroup[0];

    return response.data?.toList() ?? const <CountryListItem>[];
  }

  void _onRefresh() {
    setState(() {
      _entriesAll = [];
      _entriesFiltered = [];

      _searchController.clear();

      widget.itemSelectedCallback(null);

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
              if (widget.selectedListItem != null) {
                CountryListItem? foundItem = _entriesFiltered.where((entry) {
                  return entry.id == widget.selectedListItem!.id;
                }).firstOrNull;

                if (foundItem == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.itemSelectedCallback(_entriesFiltered[0]);
                  });
                }
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.itemSelectedCallback(_entriesFiltered[0]);
                });
              }
            } else {
              if (widget.selectedListItem != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.itemSelectedCallback(null);
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
                                    widget.selectedListItem?.id == listItem.id;
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
                                    widget.itemSelectedCallback(listItem);
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

class CountryEditorPanel extends StatefulWidget {
  const CountryEditorPanel({
    required this.showBoth,
    required this.listItem,
    required this.itemCreatedCallback,
    required this.itemSavedCallback,
    required this.itemDeletedCallback,
    super.key,
  });

  final bool showBoth;

  final CountryListItem? listItem;

  final ValueChanged<CountryListItem?> itemCreatedCallback;
  final ValueChanged<CountryListItem?> itemSavedCallback;
  final ValueChanged<CountryListItem?> itemDeletedCallback;

  @override
  State<CountryEditorPanel> createState() => _CountryEditorPanelState();
}

class _CountryEditorPanelState extends State<CountryEditorPanel> {
  final _formKey = GlobalKey<FormState>();

  final _shortcodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _flagsController = TextEditingController();
  final _ibanLengthController = TextEditingController();
  final _riskTypeController = TextEditingController();

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  bool _dbReading = false;

  late Future<Country?> _dbReadFuture;

  Future<Country?> _dbRead(CountryListItem? item) async {
    if (item != null) {
      try {
        final openapi = Openapi();

        openapi.dio.options.connectTimeout = const Duration(seconds: 10);
        openapi.dio.options.receiveTimeout = const Duration(seconds: 15);
        // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

        final response = await openapi.getCountryApi().getCountryById(
          id: item.id,
        );

        if (response.statusCode == 200) {
          return response.data;
        }
      } on DioException catch (e) {
        if ((e.type == DioExceptionType.badResponse) && (e.response != null)) {
          if (e.response!.statusCode == 404) {
            return null;
          }
        }
        rethrow;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  bool _dbInserting = false;

  //----------------------------------------------------------------------------
  // Save an existing record to database
  //----------------------------------------------------------------------------

  bool _dbSaving = false;

  Future<void> _dbSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _dbSaving = true);
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

        //----------------------------------------------------------------------

        final openapi = Openapi();

        openapi.dio.options.connectTimeout = const Duration(seconds: 5);
        openapi.dio.options.receiveTimeout = const Duration(seconds: 5);
        // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

        await openapi.getCountryApi().updateCountry(
          id: widget.listItem!.id, // TODO NULL-Value
          countryNoPK: payload,
        );

        setState(() {
          _dbReadFuture = _dbRead(widget.listItem);
        });

        final listItem = CountryListItem(
          (b) => b
            ..id = widget.listItem!.id
            ..shortcode = payload.name
            ..name = payload.shortcode,
        );

        widget.itemSavedCallback(listItem);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Speichern fehlgeschlagen: $e')));
      } finally {
        if (mounted) setState(() => _dbSaving = false);
      }
    }
  }

  //----------------------------------------------------------------------------
  // Delete a record from database
  //----------------------------------------------------------------------------

  bool _dbDeleting = false;

  Future<void> _dbDelete() async {
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
      setState(() => _dbDeleting = true);
      try {
        final openapi = Openapi();

        openapi.dio.options.connectTimeout = const Duration(seconds: 5);
        openapi.dio.options.receiveTimeout = const Duration(seconds: 5);
        // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

        // TODO NULL-Value
        await openapi.getCountryApi().deleteCountry(id: widget.listItem!.id);

        widget.itemDeletedCallback(widget.listItem);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Löschen fehlgeschlagen: $e')));
      } finally {
        if (mounted) setState(() => _dbDeleting = false);
      }
    }
  }

  //----------------------------------------------------------------------------

  bool _dbActive() {
    return _dbInserting || _dbSaving || _dbDeleting;
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _dbReadFuture = _dbRead(widget.listItem);
  }

  @override
  void didUpdateWidget(covariant CountryEditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.listItem != widget.listItem) {
      _dbReadFuture = _dbRead(widget.listItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content() {
      return FutureBuilder<Country?>(
        future: _dbReadFuture,
        builder: (context, snapshot) {
          bool isLoading = true;

          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              _dbReading = true;
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Fehler: ${snapshot.error}'));
              }

              if (snapshot.hasData) {
                if (_dbReading) {
                  final data = snapshot.data!;

                  _shortcodeController.text = data.shortcode;
                  _nameController.text = data.name;
                  _flagsController.text = data.flags.toString();
                  _ibanLengthController.text = data.ibanlenth?.toString() ?? '';
                  _riskTypeController.text = data.risktype.toString();

                  _dbReading = false;
                }

                isLoading = false;
              } else {
                return Center(child: Text('Keine Daten gefunden'));
              }
          }

          return Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
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
                        decoration: const InputDecoration(
                          labelText: 'Kürzel',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        inputFormatters: [
                          TextInputFormatter.withFunction((_, newValue) {
                            return newValue.copyWith(
                              text: newValue.text.toUpperCase(),
                            );
                          }),
                        ],
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Pflichtfeld'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        maxLength: 30,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Pflichtfeld'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _flagsController,
                        decoration: const InputDecoration(
                          labelText: 'Flags',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _riskTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Risk Type',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
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
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: _dbActive() ? null : _dbSave,
                            icon: _dbSaving
                                ? const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              _dbSaving ? 'Speichert...' : 'Speichern',
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: _dbActive() ? null : _dbDelete,
                            icon: _dbDeleting
                                ? const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.delete_outline),
                            label: Text(_dbDeleting ? 'Löscht...' : 'Löschen'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.white.withAlpha(50),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      );
    }

    if (widget.showBoth) {
      return content();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("RbsClone"),
              Opacity(
                opacity: 0.7,
                child: Text(
                  "Stammdaten - Börsen",
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
            child: Row(children: [Expanded(child: content())]),
          ),
        ),
      );
    }
  }
}
/*
class CountryEditorPanel extends StatefulWidget {
  const CountryEditorPanel({
    required this.showBoth,
    required this.country,
    required this.onSaved,
    required this.onDelete,
    super.key,
  });

  final bool showBoth;

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

  Future<void> _dbSave() async {
    if (!_formKey.currentState!.validate()) {
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
  }

  Future<void> _dbDelete() async {
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
    Widget content = Container(
      padding: const EdgeInsets.all(16),
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
                  onPressed: _saving ? null : _dbSave,
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
                  onPressed: _dbDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Löschen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (widget.showBoth) {
      return content;
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("RbsClone"),
              Opacity(
                opacity: 0.7,
                child: Text(
                  "Stammdaten - Länder",
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
            child: Row(children: [Expanded(child: content)]),
          ),
        ),
      );
    }
  }
}
*/
