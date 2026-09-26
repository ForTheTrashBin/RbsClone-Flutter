import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:rbsclone_flutter/widgets/custom_appbar.dart';

//------------------------------------------------------------------------------

class MasterDetail extends StatefulWidget {
  const MasterDetail({
    required this.mobileMode,
    required this.createMode,
    required this.listItem,
    required this.countries,
    required this.itemCreatedCallback,
    required this.itemUpdatedCallback,
    required this.itemDeletedCallback,
    super.key,
  });

  final bool mobileMode;
  final bool createMode;

  final CustodianListItem? listItem;

  final List<CountryListItem> countries;

  final ValueChanged<CustodianListItem?> itemCreatedCallback;
  final ValueChanged<CustodianListItem?> itemUpdatedCallback;
  final ValueChanged<CustodianListItem?> itemDeletedCallback;

  @override
  State<MasterDetail> createState() => _MasterDetailState();
}

class _MasterDetailState extends State<MasterDetail> {
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

  final _dbInserting = false;

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
  void didUpdateWidget(covariant MasterDetail oldWidget) {
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
                        widget.createMode
                            ? "Daten erstellen"
                            : 'Daten bearbeiten/löschen',
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

    if (widget.mobileMode) {
      return Scaffold(
        appBar: CustomAppBar("Stammdaten - Lagerstellen"),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(children: [Expanded(child: content())]),
          ),
        ),
      );
    } else {
      return content();
    }
  }
}
