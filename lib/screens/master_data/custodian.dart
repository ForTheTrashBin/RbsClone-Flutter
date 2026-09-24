import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openapi/openapi.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CustodianDataModule extends StatefulWidget {
  const CustodianDataModule(this.showBoth, {super.key});

  final bool showBoth;

  @override
  State<CustodianDataModule> createState() => _DataModuleState();
}

class _DataModuleState extends State<CustodianDataModule> {
  CustodianListItem? _selectedListItem;

  void onItemSelected(CustodianListItem? item) {
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

  //----------------------------------------------------------------------------

  void onNewCallback() {
    print("**************** _DataModuleState::onNewCallback");
  }

  //----------------------------------------------------------------------------

  final _createNotifier = ValueNotifier<CustodianListItem?>(null);

  void onItemCreated(CustodianListItem? item) {
    _createNotifier.value = item;
  }

  //----------------------------------------------------------------------------

  final _updateNotifier = ValueNotifier<CustodianListItem?>(null);

  void onItemUpdated(CustodianListItem? item) {
    _updateNotifier.value = item;
  }

  //----------------------------------------------------------------------------

  final _deleteNotifier = ValueNotifier<CustodianListItem?>(null);

  void onItemDeleted(CustodianListItem? item) {
    _deleteNotifier.value = item;
  }

  //----------------------------------------------------------------------------

  @override
  void dispose() {
    _deleteNotifier.dispose();
    _updateNotifier.dispose();
    _createNotifier.dispose();

    super.dispose();
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
            child: _MasterList(
              showBoth: widget.showBoth,
              selectedListItem: _selectedListItem,
              itemSelectedCallback: onItemSelected,
              newCallback: onNewCallback,
              createNotifier: _createNotifier,
              updateNotifier: _updateNotifier,
              deleteNotifier: _deleteNotifier,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: _EditorPanel(
              showBoth: widget.showBoth,
              listItem: _selectedListItem,
              countries: _countries,
              itemCreatedCallback: onItemCreated,
              itemUpdatedCallback: onItemUpdated,
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
                      return _EditorPanel(
                        showBoth: widget.showBoth,
                        listItem: _selectedListItem,
                        countries: _countries,
                        itemCreatedCallback: onItemCreated,
                        itemUpdatedCallback: onItemUpdated,
                        itemDeletedCallback: onItemDeleted,
                      );
                    },
                  ),
                );
              },
              newCallback: onNewCallback,
              createNotifier: _createNotifier,
              updateNotifier: _updateNotifier,
              deleteNotifier: _deleteNotifier,
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
  const _MasterList({
    required this.showBoth,
    required this.selectedListItem,
    required this.itemSelectedCallback,
    required this.newCallback,
    required this.createNotifier,
    required this.updateNotifier,
    required this.deleteNotifier,
  });

  final bool showBoth;

  final CustodianListItem? selectedListItem;

  final ValueChanged<CustodianListItem?> itemSelectedCallback;

  final VoidCallback newCallback;

  final ValueNotifier<CustodianListItem?> createNotifier;
  final ValueNotifier<CustodianListItem?> updateNotifier;
  final ValueNotifier<CustodianListItem?> deleteNotifier;

  @override
  State<_MasterList> createState() => _MasterListState();
}

class _MasterListState extends State<_MasterList> {
  List<CustodianListItem> _entriesAll = [];
  List<CustodianListItem> _entriesFiltered = [];

  final ItemScrollController _itemScrollController = ItemScrollController();

  late Future<List<CustodianListItem>> _dbFuture;

  late TextEditingController _searchController;

  Future<List<CustodianListItem>> fetchListData() async {
    final openapi = Openapi();

    openapi.dio.options.connectTimeout = const Duration(seconds: 10);
    openapi.dio.options.receiveTimeout = const Duration(seconds: 15);
    // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

    final responseFuture = openapi.getCustodianApi().getCustodians();

    final minWaitFuture = Future.delayed(Duration(milliseconds: 600));

    final waitGroup = await Future.wait([responseFuture, minWaitFuture]);

    final response = waitGroup[0];

    return response.data?.toList() ?? const <CustodianListItem>[];
  }

  void _onRefresh() {
    setState(() {
      _entriesAll = [];
      _entriesFiltered = [];

      _searchController.clear();

      widget.itemSelectedCallback(null);

      _dbFuture = fetchListData();
    });
  }

  //----------------------------------------------------------------------------

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

  void _onDataCreated() {
    print("***************************** _MasterListState::_onDataCreated");
  }

  void _scrollToItem(String id) {
    final index = _entriesFiltered.indexWhere((entry) {
      return entry.id == id;
    });

    if (index >= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_itemScrollController.isAttached) {
          _itemScrollController.scrollTo(
            index: index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.1,
          );
        }
      });
    }
  }

  void _onDataUpdated() {
    final listItem = widget.updateNotifier.value;

    if (listItem != null) {
      final indexAll = _entriesAll.indexWhere((entry) {
        return entry.id == listItem.id;
      });

      final indexFiltered = _entriesFiltered.indexWhere((entry) {
        return entry.id == listItem.id;
      });

      if ((indexAll >= 0) && (indexFiltered >= 0)) {
        bool needSort =
            ((_entriesAll[indexAll].shortcode != listItem.shortcode) ||
            (_entriesFiltered[indexFiltered].shortcode != listItem.shortcode));

        setState(() {
          _entriesAll[indexAll] = listItem;
          _entriesFiltered[indexFiltered] = listItem;

          if (needSort) {
            _entriesAll.sort((a, b) {
              return a.shortcode.toUpperCase().compareTo(
                b.shortcode.toUpperCase(),
              );
            });

            _entriesFiltered.sort((a, b) {
              return a.shortcode.toUpperCase().compareTo(
                b.shortcode.toUpperCase(),
              );
            });
          }
        });

        if (needSort) {
          _scrollToItem(listItem.id);
        }
      }
    } else {
      _onRefresh();
    }
  }

  void _onDataDeleted() {
    final listItem = widget.deleteNotifier.value;

    if (listItem != null) {
      final indexAll = _entriesAll.indexWhere((entry) {
        return entry.id == listItem.id;
      });

      final indexFiltered = _entriesFiltered.indexWhere((entry) {
        return entry.id == listItem.id;
      });

      if ((indexAll >= 0) && (indexFiltered >= 0)) {
        setState(() {
          _entriesAll.removeAt(indexAll);
          _entriesFiltered.removeAt(indexFiltered);
        });
      }
    }
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _dbFuture = fetchListData();

    _searchController = TextEditingController();

    widget.createNotifier.addListener(_onDataCreated);
    widget.updateNotifier.addListener(_onDataUpdated);
    widget.deleteNotifier.addListener(_onDataDeleted);
  }

  @override
  void dispose() {
    _searchController.dispose();

    widget.deleteNotifier.removeListener(_onDataDeleted);
    widget.updateNotifier.removeListener(_onDataUpdated);
    widget.createNotifier.removeListener(_onDataCreated);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.newCallback,
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
              if (widget.selectedListItem != null) {
                CustodianListItem? foundItem = _entriesFiltered.where((entry) {
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
                  // List of items or message, if list is empty
                  //------------------------------------------------------------
                  Expanded(
                    child: ClipRect(
                      child: _entriesFiltered.isEmpty
                          ? const Center(
                              child: Text("Keine Lagerstellen vorhanden."),
                            )
                          : ScrollablePositionedList.separated(
                              itemCount: _entriesFiltered.length,
                              itemScrollController: _itemScrollController,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final listItem = _entriesFiltered[index];
                                final isSelected =
                                    widget.selectedListItem?.id == listItem.id;
                                return ListTile(
                                  key: ValueKey(listItem.id),
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

class _EditorPanel extends StatefulWidget {
  const _EditorPanel({
    required this.showBoth,
    required this.listItem,
    required this.countries,
    required this.itemCreatedCallback,
    required this.itemUpdatedCallback,
    required this.itemDeletedCallback,
  });

  final bool showBoth;

  final CustodianListItem? listItem;

  final List<CountryListItem> countries;

  final ValueChanged<CustodianListItem?> itemCreatedCallback;
  final ValueChanged<CustodianListItem?> itemUpdatedCallback;
  final ValueChanged<CustodianListItem?> itemDeletedCallback;

  @override
  State<_EditorPanel> createState() => _EditorPanelState();
}

class _EditorPanelState extends State<_EditorPanel> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _shortcodeController;
  late TextEditingController _nameController;
  late TextEditingController _flagsController;
  late TextEditingController _depotNoController;

  String? _selectedCountryId;

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  bool _dbReading = false;

  late Future<Custodian?> _dbReadFuture;

  Future<Custodian?> _dbRead(CustodianListItem? item) async {
    if (item != null) {
      try {
        final openapi = Openapi();

        openapi.dio.options.connectTimeout = const Duration(seconds: 10);
        openapi.dio.options.receiveTimeout = const Duration(seconds: 15);
        // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

        final response = await openapi.getCustodianApi().getCustodianById(
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
      if ((_selectedCountryId == null) || (_selectedCountryId!.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitte ein Land auswählen.')),
        );
        return;
      }

      setState(() => _dbSaving = true);
      try {
        final payload = CustodianNoPK(
          (b) => b
            ..shortcode = _shortcodeController.text.trim().toUpperCase()
            ..name = _nameController.text.trim()
            ..flags = int.tryParse(_flagsController.text) ?? 0
            ..depotno = _depotNoController.text.trim()
            ..idcountry = _selectedCountryId,
        );

        //----------------------------------------------------------------------

        final openapi = Openapi();

        openapi.dio.options.connectTimeout = const Duration(seconds: 5);
        openapi.dio.options.receiveTimeout = const Duration(seconds: 5);
        // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

        await openapi.getCustodianApi().updateCustodian(
          id: widget.listItem!.id, // TODO NULL-Value
          custodianNoPK: payload,
        );

        setState(() {
          _dbReadFuture = _dbRead(widget.listItem);
        });

        final listItem = CustodianListItem(
          (b) => b
            ..id = widget.listItem!.id
            ..shortcode = payload.shortcode
            ..name = payload.name,
        );

        widget.itemUpdatedCallback(listItem);
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
      setState(() => _dbDeleting = true);
      try {
        final openapi = Openapi();

        openapi.dio.options.connectTimeout = const Duration(seconds: 5);
        openapi.dio.options.receiveTimeout = const Duration(seconds: 5);
        // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

        // TODO NULL-Value
        await openapi.getCustodianApi().deleteCustodian(
          id: widget.listItem!.id,
        );

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

    _shortcodeController = TextEditingController();
    _nameController = TextEditingController();
    _flagsController = TextEditingController();
    _depotNoController = TextEditingController();
  }

  @override
  void dispose() {
    _shortcodeController.dispose();
    _nameController.dispose();
    _flagsController.dispose();
    _depotNoController.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _EditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.listItem != widget.listItem) {
      _dbReadFuture = _dbRead(widget.listItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content() {
      return FutureBuilder<Custodian?>(
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
                  _depotNoController.text = data.depotno.toString();

                  _selectedCountryId = data.idcountry;

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
                        'Daten bearbeiten/löschen',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        maxLength: 5,
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
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCountryId,
                        decoration: const InputDecoration(
                          labelText: 'Land',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        items: widget.countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country.id,
                            child: Text(
                              '${country.shortcode} (${country.name})',
                            ),
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
                        decoration: const InputDecoration(
                          labelText: 'Depotnummer',
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
