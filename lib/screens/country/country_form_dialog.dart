import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

class CountryFormDialog extends StatefulWidget {
  const CountryFormDialog({this.country, super.key});

  final Country? country;

  @override
  State<CountryFormDialog> createState() => _CountryFormDialogState();
}

class _CountryFormDialogState extends State<CountryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shortcodeController = TextEditingController();
  final _flagsController = TextEditingController();
  final _ibanLengthController = TextEditingController();
  final _riskTypeController = TextEditingController();

  late final bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.country != null;
    final country = widget.country;
    if (country != null) {
      _nameController.text = country.name;
      _shortcodeController.text = country.shortcode;
      _flagsController.text = country.flags.toString();
      _ibanLengthController.text = country.ibanlenth?.toString() ?? '';
      _riskTypeController.text = country.risktype.toString();
    } else {
      _flagsController.text = '0';
      _riskTypeController.text = '0';
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final payload = CountryNoPK(
      (b) => b
        ..name = _nameController.text.trim()
        ..shortcode = _shortcodeController.text.trim().toUpperCase()
        ..flags = int.tryParse(_flagsController.text) ?? 0
        ..risktype = int.tryParse(_riskTypeController.text) ?? 0
        ..ibanlenth = int.tryParse(
          _ibanLengthController.text.isEmpty ? '0' : _ibanLengthController.text,
        ),
    );

    try {
      if (_isEditMode) {
        await Openapi().getCountryApi().updateCountry(
          id: widget.country!.id,
          countryNoPK: payload,
        );
      } else {
        await Openapi().getCountryApi().createCountry(countryNoPK: payload);
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
      title: Text(_isEditMode ? 'Land bearbeiten' : 'Land anlegen'),
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
