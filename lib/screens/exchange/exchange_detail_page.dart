import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

import 'exchange_form_dialog.dart';

class ExchangeDetailPage extends StatelessWidget {
  const ExchangeDetailPage({
    required this.exchange,
    required this.onRefresh,
    required this.onDelete,
    super.key,
  });

  final Exchange exchange;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exchange.name),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (_) => ExchangeFormDialog(exchange: exchange),
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
        child: ExchangeDetailPanel(
          exchange: exchange,
          onRefresh: onRefresh,
          onEdit: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => ExchangeFormDialog(exchange: exchange),
            );
            if (result == true) {
              await onRefresh();
              if (context.mounted) Navigator.of(context).pop();
            }
          },
          onDelete: () => onDelete(exchange.id),
        ),
      ),
    );
  }
}

class ExchangeDetailPanel extends StatelessWidget {
  const ExchangeDetailPanel({
    required this.exchange,
    required this.onRefresh,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Exchange exchange;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _DetailRow(label: 'ID', value: exchange.id),
      _DetailRow(label: 'Shortcode', value: exchange.shortcode),
      _DetailRow(label: 'Name', value: exchange.name),
      _DetailRow(label: 'Flags', value: exchange.flags.toString()),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.currency_exchange, size: 28),
            const SizedBox(width: 12),
            Text(
              exchange.name,
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

class ExchangeMasterList extends StatefulWidget {
  final ValueChanged<ExchangeListItem> onItemSelected;

  const ExchangeMasterList({super.key, required this.onItemSelected});

  @override
  State<ExchangeMasterList> createState() => _ExchangeMasterListState();
}

class _ExchangeMasterListState extends State<ExchangeMasterList> {
  late Future<List<ExchangeListItem>> _dbFuture;

  List<ExchangeListItem> _allEntries = [];
  List<ExchangeListItem> _filteredEntries = [];

  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = -1;

  Future<List<ExchangeListItem>> fetchExchanges() async {
    final api = Openapi();

    final responseFuture = api.getExchangeApi().getExchanges().timeout(
      const Duration(seconds: 10),
    );

    final minWaitFuture = Future.delayed(Duration(milliseconds: 600));

    final waitGroup = await Future.wait([responseFuture, minWaitFuture]);

    final response = waitGroup[0];

    return response.data?.toList() ?? const <ExchangeListItem>[];
  }

  void _onRefresh() {
    setState(() {
      _allEntries = [];
      _filteredEntries = [];

      _dbFuture = fetchExchanges();
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
                            "Börsen",
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
                          ? const Center(child: Text("Keine Börsen vorhanden."))
                          : ListView.separated(
                              itemCount: _filteredEntries.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final exchangeListItem =
                                    _filteredEntries[index];
                                final isSelected = _selectedIndex == index;
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      exchangeListItem.shortcode
                                          .substring(0, 1)
                                          .toUpperCase(),
                                    ),
                                  ),
                                  title: Text(exchangeListItem.shortcode),
                                  subtitle: Text(exchangeListItem.name),
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

                                    widget.onItemSelected(exchangeListItem);
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
                      : ExchangeEditorPanel(
                          key: ValueKey(selectedExchange!.id),
                          exchange: selectedExchange!,
                          onSaved: onRefresh,
                          onDelete: () =>
                              onDeleteExchange(selectedExchange!.id),
                        ),
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

  final ExchangeListItem exchange;
  final Future<void> Function() onSaved;
  final Future<void> Function() onDelete;

  @override
  State<ExchangeEditorPanel> createState() => _ExchangeEditorPanelState();
}

class _ExchangeEditorPanelState extends State<ExchangeEditorPanel> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _shortcodeController;
  late final TextEditingController _flagsController;
  bool _saving = false;

  void _syncControllers() {
    final exchange = widget.exchange;
    _nameController.text = exchange.name;
    _shortcodeController.text = exchange.shortcode;
    // _flagsController.text = exchange.flags.toString();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exchange.name);
    _shortcodeController = TextEditingController(
      text: widget.exchange.shortcode,
    );
    _flagsController = TextEditingController(
      text: "Dummy", // widget.exchange.flags.toString(),
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
    _nameController.dispose();
    _shortcodeController.dispose();
    _flagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final payload = ExchangeNoPK(
        (b) => b
          ..name = _nameController.text.trim()
          ..shortcode = _shortcodeController.text.trim().toUpperCase()
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
