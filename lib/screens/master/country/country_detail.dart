import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:rbsclone_flutter/widgets/custom_appbar.dart';
import 'package:rbsclone_flutter/utils/validator_utils.dart';
import 'package:rbsclone_flutter/utils/constants_util.dart';

//------------------------------------------------------------------------------

class MasterDetail extends StatefulWidget {
  const MasterDetail({
    required this.mobileMode,
    required this.createMode,
    required this.listItem,
    required this.itemCreatedCallback,
    required this.itemUpdatedCallback,
    required this.itemDeletedCallback,
    super.key,
  });

  final bool mobileMode;
  final bool createMode;

  final CountryListItem? listItem;

  final ValueChanged<CountryListItem?> itemCreatedCallback;
  final ValueChanged<CountryListItem?> itemUpdatedCallback;
  final ValueChanged<CountryListItem?> itemDeletedCallback;

  @override
  State<MasterDetail> createState() => _MasetrDetailState();
}

class _MasetrDetailState extends State<MasterDetail> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _shortcodeController;
  late TextEditingController _nameController;
  late TextEditingController _flagsController;
  late TextEditingController _ibanLengthController;
  late TextEditingController _riskTypeController;

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  void setFormDefault() {
    _shortcodeController.text = '';
    _nameController.text = '';
    _flagsController.text = '0';
    _ibanLengthController.text = '';
    _riskTypeController.text = '0';
  }

  void setFormData(Country? data) {
    if (data != null) {
      _shortcodeController.text = data.shortcode;
      _nameController.text = data.name;
      _flagsController.text = data.flags.toString();
      _ibanLengthController.text = data.ibanlength?.toString() ?? '';
      _riskTypeController.text = data.risktype.toString();
    } else {
      setFormDefault();
    }
  }

  CountryNoPK getFormPayload() {
    return CountryNoPK(
      (b) => b
        ..shortcode = _shortcodeController.text.trim().toUpperCase()
        ..name = _nameController.text.trim()
        ..flags = int.tryParse(_flagsController.text) ?? 0
        ..risktype = int.tryParse(_riskTypeController.text) ?? 0
        ..ibanlength = _ibanLengthController.text.isNotEmpty ? int.tryParse(_ibanLengthController.text) : null,
    );
  }

  CountryListItem getListItem(Country data) {
    return CountryListItem(
      (b) => b
        ..id = data.id
        ..shortcode = data.shortcode
        ..name = data.name,
    );
  }

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

        final response = await openapi.getCountryApi().getCountryById(id: item.id);

        if (response.statusCode == 200) {
          return response.data;
        }
      } on DioException catch (e) {
        if ((e.type == DioExceptionType.badResponse) && (e.response != null)) {
          if (e.response!.statusCode == DioApiStatus.notFound) {
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
  // Create a new record
  //----------------------------------------------------------------------------

  bool _dbCreating = false;

  Future<void> _dbCreate() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _dbCreating = true);

      try {
        final openapi = Openapi();

        openapi.dio.options.connectTimeout = const Duration(seconds: 5);
        openapi.dio.options.receiveTimeout = const Duration(seconds: 5);
        // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

        final response = await openapi.getCountryApi().createCountry(countryNoPK: getFormPayload());

        if ((response.statusCode == DioApiStatus.created) && (response.data != null)) {
          final responseData = response.data!;

          widget.itemCreatedCallback(getListItem(responseData));
        } else {
          throw Exception("Wrong status or data: ${response.statusCode}");
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Speichern fehlgeschlagen: $e')));
      } finally {
        if (mounted) setState(() => _dbCreating = false);
      }
    }
  }

  //----------------------------------------------------------------------------
  // Save an existing record to database
  //----------------------------------------------------------------------------

  bool _dbSaving = false;

  Future<void> _dbSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _dbSaving = true);
      try {
        final openapi = Openapi();

        openapi.dio.options.connectTimeout = const Duration(seconds: 5);
        openapi.dio.options.receiveTimeout = const Duration(seconds: 5);
        // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

        final response = await openapi.getCountryApi().updateCountry(
          id: widget.listItem!.id,
          countryNoPK: getFormPayload(),
        );

        if ((response.statusCode == DioApiStatus.ok) && (response.data != null)) {
          final responseData = response.data!;

          widget.itemUpdatedCallback(getListItem(responseData));
        } else {
          throw Exception("Wrong status or data: ${response.statusCode}");
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Speichern fehlgeschlagen: $e')));
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
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Löschen')),
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

        final response = await openapi.getCountryApi().deleteCountry(id: widget.listItem!.id);

        if (response.statusCode == DioApiStatus.noContent) {
          widget.itemDeletedCallback(widget.listItem);
        } else {
          throw Exception("Wrong status: ${response.statusCode}");
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Löschen fehlgeschlagen: $e')));
      } finally {
        if (mounted) setState(() => _dbDeleting = false);
      }
    }
  }

  //----------------------------------------------------------------------------

  bool _dbActive() {
    return _dbCreating || _dbSaving || _dbDeleting;
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _shortcodeController = TextEditingController();
    _nameController = TextEditingController();
    _flagsController = TextEditingController();
    _ibanLengthController = TextEditingController();
    _riskTypeController = TextEditingController();

    if (widget.createMode) {
      _dbReadFuture = _dbRead(null);

      setFormDefault();
    } else {
      _dbReadFuture = _dbRead(widget.listItem);
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

  @override
  void didUpdateWidget(covariant MasterDetail oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.createMode && widget.createMode) {
      _dbReadFuture = _dbRead(null);

      setFormDefault();
    } else {
      if ((oldWidget.createMode && !widget.createMode) || (oldWidget.listItem != widget.listItem)) {
        _dbReadFuture = _dbRead(widget.listItem);
      }
    }
  }

  Widget createButtonRow() {
    return widget.createMode
        ? Row(
            children: [
              FilledButton.icon(
                onPressed: _dbActive() ? null : _dbCreate,
                icon: _dbCreating
                    ? const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save),
                label: Text(_dbCreating ? 'Speichert...' : 'Speichern'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _dbActive()
                    ? null
                    : () {
                        widget.itemCreatedCallback(null);
                      },
                icon: const Icon(Icons.delete_outline),
                label: Text('Abbrechen'),
              ),
            ],
          )
        : Row(
            children: [
              FilledButton.icon(
                onPressed: _dbActive() ? null : _dbSave,
                icon: _dbSaving
                    ? const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save),
                label: Text(_dbSaving ? 'Speichert...' : 'Speichern'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _dbActive() ? null : _dbDelete,
                icon: _dbDeleting
                    ? const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.delete_outline),
                label: Text(_dbDeleting ? 'Löscht...' : 'Löschen'),
              ),
            ],
          );
  }

  Container createFormWidgets() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              widget.createMode ? "Daten neu erstellen" : 'Daten bearbeiten/löschen',
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
                  return newValue.copyWith(text: newValue.text.toUpperCase());
                }),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Pflichtfeld';
                }
                if (value.trim().length != 2) {
                  return 'Muss genau 2 Zeichen lang sein';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              maxLength: 80,
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', floatingLabelBehavior: FloatingLabelBehavior.always),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Pflichtfeld' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _flagsController,
              decoration: const InputDecoration(
                labelText: 'Flags',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              validator: validateFlags,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ibanLengthController,
              decoration: const InputDecoration(
                labelText: 'IBAN Länge (optional)',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              validator: validateIbanLength,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _riskTypeController,
              decoration: const InputDecoration(
                labelText: 'Risk Type',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              validator: validateRiskType,
            ),
            const SizedBox(height: 20),
            createButtonRow(),
          ],
        ),
      ),
    );
  }

  Widget createFutureFormWidgets() {
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
                setFormData(snapshot.data);

                _dbReading = false;
              }

              isLoading = false;
            } else {
              return Center(child: Text('Keine Daten gefunden'));
            }
        }

        return Stack(
          children: [
            createFormWidgets(),
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

  @override
  Widget build(BuildContext context) {
    if (widget.mobileMode) {
      return Scaffold(
        appBar: CustomAppBar("Stammdaten - Länder", autoLeading: !widget.createMode),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [Expanded(child: widget.createMode ? createFormWidgets() : createFutureFormWidgets())],
            ),
          ),
        ),
      );
    } else {
      return widget.createMode ? createFormWidgets() : createFutureFormWidgets();
    }
  }
}
