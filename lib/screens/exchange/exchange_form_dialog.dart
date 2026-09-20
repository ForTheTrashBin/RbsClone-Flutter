import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

class ExchangeFormDialog extends StatefulWidget {
  const ExchangeFormDialog({this.exchange, super.key});

  final Exchange? exchange;

  @override
  State<ExchangeFormDialog> createState() => _ExchangeFormDialogState();
}

class _ExchangeFormDialogState extends State<ExchangeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shortcodeController = TextEditingController();
  final _flagsController = TextEditingController();

  late final bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.exchange != null;
    final exchange = widget.exchange;
    if (exchange != null) {
      _nameController.text = exchange.name;
      _shortcodeController.text = exchange.shortcode;
      _flagsController.text = exchange.flags.toString();
    } else {
      _flagsController.text = '0';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortcodeController.dispose();
    _flagsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final payload = ExchangeNoPK(
      (b) => b
        ..name = _nameController.text.trim()
        ..shortcode = _shortcodeController.text.trim().toUpperCase()
        ..flags = int.tryParse(_flagsController.text) ?? 0,
    );

    try {
      if (_isEditMode) {
        await Openapi().getExchangeApi().updateExchange(
          id: widget.exchange!.id,
          exchangeNoPK: payload,
        );
      } else {
        await Openapi().getExchangeApi().createExchange(exchangeNoPK: payload);
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
      title: Text(_isEditMode ? 'Börse bearbeiten' : 'Börse anlegen'),
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
                  decoration: const InputDecoration(labelText: 'Kürzel'),
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
