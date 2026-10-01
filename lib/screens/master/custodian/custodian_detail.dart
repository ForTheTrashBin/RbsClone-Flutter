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

class _MasterDetailState extends State<MasterDetail>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _shortcodeController;
  late TextEditingController _nameController;
  late TextEditingController _flagsController;
  late TextEditingController _depotNoController;

  late TabController _tabController;

  String? _selectedCountryId;

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  void setFormDefault() {
    _shortcodeController.text = '';
    _nameController.text = '';
    _flagsController.text = '0';
    _depotNoController.text = '';

    _selectedCountryId = null;
  }

  void setFormData(Custodian? data) {
    if (data != null) {
      _shortcodeController.text = data.shortcode;
      _nameController.text = data.name;
      _flagsController.text = data.flags.toString();
      _depotNoController.text = data.depotno != null
          ? data.depotno.toString()
          : '';

      _selectedCountryId = data.idcountry;
    } else {
      setFormDefault();
    }
  }

  CustodianNoPK getFormPayload() {
    final depotno = _depotNoController.text.trim();

    return CustodianNoPK(
      (b) => b
        ..shortcode = _shortcodeController.text.trim().toUpperCase()
        ..name = _nameController.text.trim()
        ..flags = int.tryParse(_flagsController.text) ?? 0
        ..depotno = depotno.isNotEmpty ? depotno : null
        ..idcountry = _selectedCountryId,
    );
  }

  CustodianListItem getListItem(Custodian data) {
    return CustodianListItem(
      (b) => b
        ..id = data.id
        ..shortcode = data.shortcode
        ..name = data.name,
    );
  }

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

        final response = await openapi.getCustodianApi().createCustodian(
          custodianNoPK: getFormPayload(),
        );

        if ((response.statusCode == DioApiStatus.created) &&
            (response.data != null)) {
          final responseData = response.data!;

          widget.itemCreatedCallback(getListItem(responseData));
        } else {
          throw Exception("Wrong status or data: ${response.statusCode}");
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Speichern fehlgeschlagen: $e')));
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
      if ((_selectedCountryId == null) || (_selectedCountryId!.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitte ein Land auswählen.')),
        );
        return;
      }

      setState(() => _dbSaving = true);
      try {
        final openapi = Openapi();

        openapi.dio.options.connectTimeout = const Duration(seconds: 5);
        openapi.dio.options.receiveTimeout = const Duration(seconds: 5);
        // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

        final response = await openapi.getCustodianApi().updateCustodian(
          id: widget.listItem!.id,
          custodianNoPK: getFormPayload(),
        );

        if ((response.statusCode == DioApiStatus.ok) &&
            (response.data != null)) {
          final resonseData = response.data!;

          widget.itemUpdatedCallback(getListItem(resonseData));
        } else {
          throw Exception("Wrong status or data: ${response.statusCode}");
        }
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

        final response = await openapi.getCustodianApi().deleteCustodian(
          id: widget.listItem!.id,
        );

        if (response.statusCode == DioApiStatus.noContent) {
          widget.itemDeletedCallback(widget.listItem);
        } else {
          throw Exception("Wrong status: ${response.statusCode}");
        }
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
    return _dbCreating || _dbSaving || _dbDeleting;
  }

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();

    _shortcodeController = TextEditingController();
    _nameController = TextEditingController();
    _flagsController = TextEditingController();
    _depotNoController = TextEditingController();

    _tabController = TabController(length: 2, vsync: this);

    // Aktualisiert die Anzeige, wenn der Nutzer auf einen Tab tippt
    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.index != _activeTabIndex) {
        setState(() {
          _activeTabIndex = _tabController.index;
        });
      }
    });

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
    _depotNoController.dispose();

    _tabController.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MasterDetail oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.createMode && widget.createMode) {
      _dbReadFuture = _dbRead(null);

      setFormDefault();
    } else {
      if ((oldWidget.createMode && !widget.createMode) ||
          (oldWidget.listItem != widget.listItem)) {
        _dbReadFuture = _dbRead(widget.listItem);
      }
    }
  }

  Widget buildButtonRow() {
    return widget.createMode
        ? Row(
            children: [
              FilledButton.icon(
                onPressed: _dbActive() ? null : _dbCreate,
                icon: _dbCreating
                    ? const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
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
                    ? const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_dbSaving ? 'Speichert...' : 'Speichern'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _dbActive() ? null : _dbDelete,
                icon: _dbDeleting
                    ? const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_outline),
                label: Text(_dbDeleting ? 'Löscht...' : 'Löschen'),
              ),
            ],
          );
  }

  Widget buildTabPageOne() {
    return Column(
      children: [
        TextFormField(
          maxLength: 5,
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
          validator: (value) =>
              (value == null || value.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          maxLength: 80,
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          validator: (value) =>
              (value == null || value.trim().isEmpty) ? 'Pflichtfeld' : null,
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
        const SizedBox(height: 16),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: _selectedCountryId,
            decoration: const InputDecoration(
              labelText: 'Land',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 40.0, 40.0),
            ),
            items: widget.countries.map((country) {
              return DropdownMenuItem<String>(
                value: country.id,
                child: Text(
                  '${country.shortcode} (${country.name})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) =>
                setState(() => _selectedCountryId = value ?? ''),
            validator: (value) => value == null || value.isEmpty
                ? 'Bitte ein Land auswählen'
                : null,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          maxLength: 10,
          controller: _depotNoController,
          decoration: const InputDecoration(
            labelText: 'Depotnummer (optional)',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget buildTabPageTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Content Tab Two"),
        const SizedBox(height: 12),
        Text("Content Tab Two"),
        const SizedBox(height: 12),
        Text("Content Tab Two"),
        const SizedBox(height: 12),
        Text("Content Tab Two"),
        const SizedBox(height: 12),
        Text("Content Tab Two"),
      ],
    );
  }

  Widget buildFormWidgets() {
    return Align(
      alignment: Alignment.topLeft,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.createMode
                    ? "Daten neu erstellen"
                    : 'Daten bearbeiten/löschen',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              // const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Stammdaten"),
                  Tab(text: "Börsen-Zuordnung"),
                ],
              ),
              const SizedBox(height: 16),
              IntrinsicHeight(
                child: IndexedStack(
                  index: _activeTabIndex,
                  children: [
                    // TAB 1
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: _activeTabIndex == 0 ? 1.0 : 0.0,
                      child: buildTabPageOne(),
                    ),

                    // TAB 2 (Wird flüssig eingeblendet, hält im Stack aber die Höhe stabil!)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: _activeTabIndex == 1 ? 1.0 : 0.0,
                      child: buildTabPageTwo(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildButtonRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFutureFormWidgets() {
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
            buildFormWidgets(),
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
        appBar: CustomAppBar(
          "Stammdaten - Lagerstellen",
          autoLeading: !widget.createMode,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: widget.createMode
                      ? buildFormWidgets()
                      : buildFutureFormWidgets(),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return widget.createMode ? buildFormWidgets() : buildFutureFormWidgets();
    }
  }
}
