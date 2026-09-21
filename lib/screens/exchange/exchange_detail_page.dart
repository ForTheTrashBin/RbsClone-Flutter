import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openapi/openapi.dart';

import 'exchange_form_dialog.dart';

class ExchangeDataModule extends StatefulWidget {
  const ExchangeDataModule(this.showBoth, {super.key});

  final bool showBoth;

  @override
  State<ExchangeDataModule> createState() => _DataModuleState();
}

class _DataModuleState extends State<ExchangeDataModule> {
  Exchange? _selectedItem;

  void onItemSelected(ExchangeListItem? item) async {
    if (item != null) {
      if ((_selectedItem == null) || (_selectedItem!.id != item.id)) {
        final api = Openapi();

        Exchange? newItem;

        try {
          final response = await api
              .getExchangeApi()
              .getExchangeById(id: item.id)
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

  @override
  void initState() {
    super.initState();
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
                : ExchangeEditorPanel(
                    exchange: _selectedItem!,
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
  final ValueChanged<ExchangeListItem?> onItemSelected;

  final bool showBoth;

  const _MasterList(this.onItemSelected, this.showBoth);

  @override
  State<_MasterList> createState() => _MasterListState();
}

class _MasterListState extends State<_MasterList> {
  ExchangeListItem? _selectedItem;

  List<ExchangeListItem> _entriesAll = [];
  List<ExchangeListItem> _entriesFiltered = [];

  late Future<List<ExchangeListItem>> _dbFuture;

  Future<List<ExchangeListItem>> fetchExchanges() async {
    final responseFuture = Openapi().getExchangeApi().getExchanges().timeout(
      const Duration(seconds: 10),
    );

    final minWaitFuture = Future.delayed(Duration(milliseconds: 600));

    final waitGroup = await Future.wait([responseFuture, minWaitFuture]);

    final response = waitGroup[0];

    return response.data?.toList() ?? const <ExchangeListItem>[];
  }

  void _onRefresh() {
    setState(() {
      _entriesAll = [];
      _entriesFiltered = [];

      _selectedItem = null;

      _searchController.clear();

      widget.onItemSelected(null);

      _dbFuture = fetchExchanges();
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

    _dbFuture = fetchExchanges();
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
      body: FutureBuilder<List<ExchangeListItem>>(
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
                ExchangeListItem? foundItem = _entriesFiltered.where((entry) {
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
                          ? const Center(child: Text("Keine Börsen vorhanden."))
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

class ExchangeMasterPanel extends StatelessWidget {
  const ExchangeMasterPanel({
    required this.exchanges,
    required this.loading,
    required this.error,
    required this.selectedExchange,
    required this.onSelectExchange,
    required this.onRefresh,
    required this.onNewExchange,
    required this.onEditExchange,
    required this.onDeleteExchange,
    super.key,
  });

  final List<ExchangeListItem> exchanges;
  final bool loading;
  final String? error;
  final ExchangeListItem? selectedExchange;
  final ValueChanged<ExchangeListItem> onSelectExchange;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onNewExchange;
  final Future<void> Function(Exchange exchange) onEditExchange;
  final Future<void> Function(String id) onDeleteExchange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange'),
        actions: [
          IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => const ExchangeFormDialog(),
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
          : exchanges.isEmpty
          ? const Center(child: Text('Keine Börsen vorhanden.'))
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.separated(
                    itemCount: exchanges.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final exchange = exchanges[index];
                      final isSelected = selectedExchange?.id == exchange.id;
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
                            exchange.shortcode.substring(0, 1).toUpperCase(),
                          ),
                        ),
                        title: Text(exchange.shortcode),
                        subtitle: Text(exchange.name),
                        onTap: () => onSelectExchange(exchange),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: selectedExchange == null
                      ? const Center(child: Text('Bitte Datensatz auswählen.'))
                      : const Center(child: Text('??????? TEST ???????.')),
                  /*
                      : ExchangeEditorPanel(
                          key: ValueKey(selectedExchange!.id),
                          exchange: selectedExchange!,
                          onSaved: onRefresh,
                          onDelete: () =>
                              onDeleteExchange(selectedExchange!.id),
                        ),*/
                ),
              ],
            ),
    );
  }
}

class ExchangeEditorPanel extends StatefulWidget {
  const ExchangeEditorPanel({
    required this.exchange,
    required this.onSaved,
    required this.onDelete,
    super.key,
  });

  final Exchange exchange;

  final Future<void> Function() onSaved;
  final Future<void> Function() onDelete;

  @override
  State<ExchangeEditorPanel> createState() => _ExchangeEditorPanelState();
}

class _ExchangeEditorPanelState extends State<ExchangeEditorPanel> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _shortcodeController;
  late final TextEditingController _nameController;
  late final TextEditingController _flagsController;

  bool _saving = false;

  void _syncControllers() {
    final exchange = widget.exchange;

    _shortcodeController.text = exchange.shortcode;
    _nameController.text = exchange.name;
    _flagsController.text = exchange.flags.toString();
  }

  @override
  void initState() {
    super.initState();
    _shortcodeController = TextEditingController(
      text: widget.exchange.shortcode,
    );
    _nameController = TextEditingController(text: widget.exchange.name);
    _flagsController = TextEditingController(
      text: widget.exchange.flags.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant ExchangeEditorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exchange != widget.exchange) {
      _syncControllers();
    }
  }

  @override
  void dispose() {
    _shortcodeController.dispose();
    _nameController.dispose();
    _flagsController.dispose();
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // Save a (modified) record to database
  //----------------------------------------------------------------------------

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final payload = ExchangeNoPK(
        (b) => b
          ..shortcode = _shortcodeController.text.trim().toUpperCase()
          ..name = _nameController.text.trim()
          ..flags = int.tryParse(_flagsController.text) ?? 0,
      );

      await Openapi().getExchangeApi().updateExchange(
        id: widget.exchange.id,
        exchangeNoPK: payload,
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

  //----------------------------------------------------------------------------
  // Delete a record from database
  //----------------------------------------------------------------------------

  Future<void> _delete() async {
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
              maxLength: 8,
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
              maxLength: 80,
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
