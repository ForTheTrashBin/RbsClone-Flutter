import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:rbsclone_flutter/widgets/custom_appbar.dart';
import 'package:rbsclone_flutter/utils/validator_utils.dart';
import 'package:rbsclone_flutter/utils/constants_util.dart';

//------------------------------------------------------------------------------

class _CustodianExchangeAssignment {
  _CustodianExchangeAssignment({
    required this.exchange,
    this.value1 = 0,
    this.value2 = 0,
  });

  final ExchangeListItem exchange;
  int value1 = 0;
  int value2 = 0;
}

class _CustodianFormData {
  const _CustodianFormData({
    required this.custodian,
    required this.assignments,
    required this.defaultExchangeId,
  });

  final Custodian custodian;
  final List<_CustodianExchangeAssignment> assignments;
  final String? defaultExchangeId;
}

class MasterDetail extends StatefulWidget {
  const MasterDetail({
    required this.mobileMode,
    required this.createMode,
    required this.listItem,
    required this.countries,
    required this.exchanges,
    required this.itemCreatedCallback,
    required this.itemUpdatedCallback,
    required this.itemDeletedCallback,
    super.key,
  });

  final bool mobileMode;
  final bool createMode;

  final CustodianListItem? listItem;

  final List<CountryListItem> countries;
  final List<ExchangeListItem> exchanges;

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

  final List<_CustodianExchangeAssignment> _exchangeAssignments = [];

  String? _selectedCountryId;
  String? _selectedAvailableExchangeId;
  String? _selectedAssignedExchangeId;
  String? _defaultExchangeId;

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  void setFormDefault() {
    _shortcodeController.text = '';
    _nameController.text = '';
    _flagsController.text = '0';
    _depotNoController.text = '';

    _selectedCountryId = null;
  }

  void setFormData(_CustodianFormData? data) {
    if (data != null) {
      final custodian = data.custodian;
      _shortcodeController.text = custodian.shortcode;
      _nameController.text = custodian.name;
      _flagsController.text = custodian.flags.toString();
      _depotNoController.text = custodian.depotno != null
          ? custodian.depotno.toString()
          : '';

      _selectedCountryId = custodian.idcountry;
      _exchangeAssignments
        ..clear()
        ..addAll(data.assignments);
      _defaultExchangeId = data.defaultExchangeId;
      _selectedAssignedExchangeId = data.assignments.isEmpty
          ? null
          : data.assignments.first.exchange.id;
      _selectedAvailableExchangeId = null;
    } else {
      setFormDefault();
      _exchangeAssignments.clear();
      _defaultExchangeId = null;
      _selectedAssignedExchangeId = null;
      _selectedAvailableExchangeId = null;
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
        ..idcountry = _selectedCountryId
        ..idexchangedefault = _defaultExchangeId
        ..exchanges.addAll(
          _sortedAssignments.map(
            (assignment) => Exchange2CustodianListItem(
              (itemBuilder) => itemBuilder
                ..idexchange = assignment.exchange.id
                ..value1 = assignment.value1
                ..value2 = assignment.value2,
            ),
          ),
        ),
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

  late Future<_CustodianFormData?> _dbReadFuture;

  Future<_CustodianFormData?> _dbRead(CustodianListItem? item) async {
    if (item != null) {
      final openapi = Openapi();

      openapi.dio.options.connectTimeout = const Duration(seconds: 10);
      openapi.dio.options.receiveTimeout = const Duration(seconds: 15);

      late Custodian custodian;
      try {
        final response = await openapi.getCustodianApi().getCustodianById(
          id: item.id,
        );

        if (response.statusCode != DioApiStatus.ok || response.data == null) {
          throw StateError('Lagerstelle konnte nicht geladen werden.');
        }

        custodian = response.data!;
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

      final exchangesById = {
        for (final exchange in widget.exchanges) exchange.id: exchange,
      };
      final assignments = <_CustodianExchangeAssignment>[];
      final exchangeAssignments =
          custodian.exchanges?.toList() ?? const <Exchange2CustodianListItem>[];
      for (final assignment in exchangeAssignments) {
        final exchange = exchangesById[assignment.idexchange];
        if (exchange == null) {
          throw StateError(
            'Die zugeordnete Börse ${assignment.idexchange} ist nicht verfügbar.',
          );
        }

        assignments.add(
          _CustodianExchangeAssignment(
            exchange: exchange,
            value1: assignment.value1,
            value2: assignment.value2,
          ),
        );
      }

      final defaultExchangeId = custodian.idexchangedefault;
      if (assignments.isNotEmpty &&
          !assignments.any(
            (assignment) => assignment.exchange.id == defaultExchangeId,
          )) {
        throw StateError(
          'Die Default-Börse ist keiner zugeordneten Börse zugeordnet.',
        );
      }

      return _CustodianFormData(
        custodian: custodian,
        assignments: assignments,
        defaultExchangeId: defaultExchangeId,
      );
    }

    return null;
  }

  bool _validateExchangeAssignments() {
    if (_exchangeAssignments.isEmpty) {
      return true;
    }

    if (_defaultExchangeId == null ||
        !_exchangeAssignments.any(
          (assignment) => assignment.exchange.id == _defaultExchangeId,
        )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte eine Default-Börse festlegen.')),
      );
      return false;
    }

    return true;
  }

  //----------------------------------------------------------------------------
  // Create a new record
  //----------------------------------------------------------------------------

  bool _dbCreating = false;

  Future<void> _dbCreate() async {
    if (_formKey.currentState!.validate() && _validateExchangeAssignments()) {
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
          widget.itemCreatedCallback(getListItem(response.data!));
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
    if (_formKey.currentState!.validate() && _validateExchangeAssignments()) {
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
          widget.itemUpdatedCallback(getListItem(response.data!));
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

  List<ExchangeListItem> get _sortedExchanges {
    return [...widget.exchanges]..sort((a, b) {
      return a.shortcode.toUpperCase().compareTo(b.shortcode.toUpperCase());
    });
  }

  List<_CustodianExchangeAssignment> get _sortedAssignments {
    final assignmentsById = {
      for (final assignment in _exchangeAssignments)
        assignment.exchange.id: assignment,
    };

    return [
      for (final exchange in _sortedExchanges) ?assignmentsById[exchange.id],
    ];
  }

  List<ExchangeListItem> get _availableExchanges {
    final assignedIds = _exchangeAssignments
        .map((assignment) => assignment.exchange.id)
        .toSet();

    return _sortedExchanges
        .where((exchange) => !assignedIds.contains(exchange.id))
        .toList();
  }

  _CustodianExchangeAssignment? get _selectedAssignment {
    for (final assignment in _exchangeAssignments) {
      if (assignment.exchange.id == _selectedAssignedExchangeId) {
        return assignment;
      }
    }
    return null;
  }

  void _assignExchange(String exchangeId) {
    final available = _availableExchanges;
    final sourceIndex = available.indexWhere(
      (exchange) => exchange.id == exchangeId,
    );
    if (sourceIndex < 0) return;

    final exchange = available[sourceIndex];
    final remainingAvailable = [...available]..removeAt(sourceIndex);
    final nextAvailableId = remainingAvailable.isEmpty
        ? null
        : remainingAvailable[sourceIndex < remainingAvailable.length
                  ? sourceIndex
                  : remainingAvailable.length - 1]
              .id;

    setState(() {
      _exchangeAssignments.add(
        _CustodianExchangeAssignment(exchange: exchange),
      );
      _defaultExchangeId ??= exchange.id;
      _selectedAvailableExchangeId = nextAvailableId;
      _selectedAssignedExchangeId = exchange.id;
    });
  }

  void _assignSelectedExchange() {
    final selectedId = _selectedAvailableExchangeId;
    if (selectedId != null) _assignExchange(selectedId);
  }

  void _removeExchange(String exchangeId) {
    final assignments = _sortedAssignments;
    final sourceIndex = assignments.indexWhere(
      (assignment) => assignment.exchange.id == exchangeId,
    );
    if (sourceIndex < 0) return;

    final remainingAssignments = [...assignments]..removeAt(sourceIndex);
    final nextAssignedId = remainingAssignments.isEmpty
        ? null
        : remainingAssignments[sourceIndex < remainingAssignments.length
                  ? sourceIndex
                  : remainingAssignments.length - 1]
              .exchange
              .id;
    final removedDefault = exchangeId == _defaultExchangeId;
    setState(() {
      _exchangeAssignments.removeWhere(
        (assignment) => assignment.exchange.id == exchangeId,
      );
      _selectedAssignedExchangeId = nextAssignedId;
      _selectedAvailableExchangeId = exchangeId;

      if (removedDefault) {
        final remaining = _sortedAssignments;
        _defaultExchangeId = remaining.isEmpty
            ? null
            : remaining.first.exchange.id;
      }
    });
  }

  void _removeSelectedExchange() {
    final selectedId = _selectedAssignedExchangeId;
    if (selectedId != null) _removeExchange(selectedId);
  }

  void _setDefaultExchange(String exchangeId) {
    if (exchangeId == _defaultExchangeId) return;

    setState(() {
      _defaultExchangeId = exchangeId;
    });
  }

  void _updateAssignmentValue(
    _CustodianExchangeAssignment assignment,
    String value, {
    required bool isValue1,
  }) {
    final parsedValue = int.tryParse(value);
    if (parsedValue == null || parsedValue < 0 || parsedValue > 255) {
      return;
    }

    setState(() {
      if (isValue1) {
        assignment.value1 = parsedValue;
      } else {
        assignment.value2 = parsedValue;
      }
    });
  }

  Widget _buildExchangeListPanel({
    required String title,
    required int count,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text('$count'),
            ],
          ),
        ),
        Container(
          height: 184,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              type: MaterialType.transparency,
              clipBehavior: Clip.hardEdge,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableExchangePanel() {
    final exchanges = _availableExchanges;

    return _buildExchangeListPanel(
      title: 'Verfügbare Börsen',
      count: exchanges.length,
      child: exchanges.isEmpty
          ? const Center(child: Text('Keine freien Börsen'))
          : ListView.separated(
              itemCount: exchanges.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final exchange = exchanges[index];
                return GestureDetector(
                  onDoubleTap: () => _assignExchange(exchange.id),
                  child: ListTile(
                    dense: true,
                    selected: exchange.id == _selectedAvailableExchangeId,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.45),
                    title: Text(exchange.shortcode),
                    subtitle: Text(
                      exchange.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => setState(() {
                      _selectedAvailableExchangeId = exchange.id;
                      _selectedAssignedExchangeId = null;
                    }),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAssignedExchangePanel() {
    final assignments = _sortedAssignments;

    return _buildExchangeListPanel(
      title: 'Zugeordnete Börsen',
      count: assignments.length,
      child: assignments.isEmpty
          ? const Center(child: Text('Noch keine Börse zugeordnet'))
          : ListView.separated(
              itemCount: assignments.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                final exchange = assignment.exchange;
                final isDefault = exchange.id == _defaultExchangeId;

                return GestureDetector(
                  onDoubleTap: () => _removeExchange(exchange.id),
                  child: ListTile(
                    dense: true,
                    selected: exchange.id == _selectedAssignedExchangeId,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.45),
                    title: Text(exchange.shortcode),
                    subtitle: Text(
                      exchange.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      tooltip: isDefault
                          ? 'Default-Börse'
                          : 'Als Default-Börse festlegen',
                      onPressed: isDefault
                          ? null
                          : () => _setDefaultExchange(exchange.id),
                      icon: Icon(
                        isDefault ? Icons.star : Icons.star_outline,
                        color: isDefault
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    onTap: () => setState(() {
                      _selectedAssignedExchangeId = exchange.id;
                      _selectedAvailableExchangeId = null;
                    }),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildTransferButtons({required bool vertical}) {
    final addButton = IconButton.filledTonal(
      tooltip: 'Ausgewählte Börse zuordnen',
      onPressed: _selectedAvailableExchangeId == null
          ? null
          : _assignSelectedExchange,
      icon: vertical
          ? const Icon(Icons.arrow_forward)
          : const Icon(Icons.arrow_downward),
    );

    final removeButton = IconButton.filledTonal(
      tooltip: 'Ausgewählte Börse entfernen',
      onPressed: _selectedAssignedExchangeId == null
          ? null
          : _removeSelectedExchange,
      icon: vertical
          ? const Icon(Icons.arrow_back)
          : const Icon(Icons.arrow_upward),
    );

    if (vertical) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [addButton, SizedBox(height: 12), removeButton],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [addButton, const SizedBox(width: 12), removeButton],
      );
    }
  }

  Widget _buildAssignmentPayload({required bool horizontal}) {
    final assignment = _selectedAssignment;
    if (assignment == null) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: Text('Wähle eine zugeordnete Börse für ihre Nutzdaten aus.'),
      );
    }

    final fields = [
      TextFormField(
        key: ValueKey('exchange-value1-${assignment.exchange.id}'),
        initialValue: assignment.value1.toString(),
        decoration: const InputDecoration(labelText: 'Wert 1'),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        validator: _validateAssignmentValue,
        onChanged: (value) =>
            _updateAssignmentValue(assignment, value, isValue1: true),
      ),
      TextFormField(
        key: ValueKey('exchange-value2-${assignment.exchange.id}'),
        initialValue: assignment.value2.toString(),
        decoration: const InputDecoration(labelText: 'Wert 2'),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        validator: _validateAssignmentValue,
        onChanged: (value) =>
            _updateAssignmentValue(assignment, value, isValue1: false),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nutzdaten für ${assignment.exchange.shortcode}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (horizontal)
          Row(
            children: [
              Expanded(child: fields[0]),
              const SizedBox(width: 16),
              Expanded(child: fields[1]),
            ],
          )
        else ...[
          fields[0],
          const SizedBox(height: 8),
          fields[1],
        ],
      ],
    );
  }

  String? _validateAssignmentValue(String? value) {
    final parsedValue = int.tryParse(value ?? '');
    if (parsedValue == null || parsedValue < 0 || parsedValue > 255) {
      return 'Wert muss zwischen 0 und 255 liegen.';
    }
    return null;
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

    if (oldWidget.createMode != widget.createMode ||
        oldWidget.listItem?.id != widget.listItem?.id) {
      _exchangeAssignments.clear();
      _selectedAvailableExchangeId = null;
      _selectedAssignedExchangeId = null;
      _defaultExchangeId = null;
    }

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _buildAvailableExchangePanel()),
                  const SizedBox(width: 8),
                  _buildTransferButtons(vertical: true),
                  const SizedBox(width: 8),
                  Expanded(child: _buildAssignedExchangePanel()),
                ],
              )
            else ...[
              _buildAvailableExchangePanel(),
              const SizedBox(height: 12),
              _buildTransferButtons(vertical: false),
              _buildAssignedExchangePanel(),
            ],
            const SizedBox(height: 16),
            _buildAssignmentPayload(horizontal: constraints.maxWidth >= 480),
          ],
        );
      },
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
              IndexedStack(
                index: _activeTabIndex,
                children: [
                  _activeTabIndex == 0 ? buildTabPageOne() : const SizedBox(),
                  _activeTabIndex == 1 ? buildTabPageTwo() : const SizedBox(),
                ],
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
    return FutureBuilder<_CustodianFormData?>(
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
