import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

class CustodianFormDialog extends StatefulWidget {
  const CustodianFormDialog({
    required this.countries,
    this.custodian,
    super.key,
  });

  final List<CountryListItem> countries;
  final Custodian? custodian;

  @override
  State<CustodianFormDialog> createState() => _CustodianFormDialogState();
}

class _CustodianFormDialogState extends State<CustodianFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shortcodeController = TextEditingController();
  final _depotNoController = TextEditingController();
  final _flagsController = TextEditingController();

  late final bool _isEditMode;
  String? _selectedCountryId;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.custodian != null;
    final custodian = widget.custodian;

    if (custodian != null) {
      _nameController.text = custodian.name;
      _shortcodeController.text = custodian.shortcode;
      _depotNoController.text = custodian.depotno.toString();
      _flagsController.text = custodian.flags.toString();
      _selectedCountryId = custodian.idcountry;
    } else {
      _flagsController.text = '0';
      _depotNoController.text = '0';
      _selectedCountryId = widget.countries.isNotEmpty
          ? widget.countries.first.id
          : null;
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCountryId == null || _selectedCountryId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte ein Land auswählen.')),
      );
      return;
    }

    final payload = CustodianNoPK(
      (b) => b
        ..name = _nameController.text.trim()
        ..shortcode = _shortcodeController.text.trim().toUpperCase()
        ..depotno = _depotNoController.text.trim()
        ..flags = int.tryParse(_flagsController.text) ?? 0
        ..idcountry = _selectedCountryId!,
    );

    try {
      if (_isEditMode) {
        await Openapi().getCustodianApi().updateCustodian(
          id: widget.custodian!.id,
          custodianNoPK: payload,
        );
      } else {
        await Openapi().getCustodianApi().createCustodian(
          custodianNoPK: payload,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
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
      title: Text(
        _isEditMode ? 'Lagerstelle bearbeiten' : 'Lagerstelle anlegen',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                      setState(() => _selectedCountryId = value),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Bitte ein Land auswählen'
                      : null,
                ),
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
