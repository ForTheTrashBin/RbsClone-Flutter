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
