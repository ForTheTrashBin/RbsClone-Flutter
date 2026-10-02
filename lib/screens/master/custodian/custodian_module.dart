import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:rbsclone_flutter/screens/master/custodian/custodian_detail.dart';
import 'package:rbsclone_flutter/screens/master/custodian/custodian_list.dart';

//------------------------------------------------------------------------------

class _CustodianReferenceData {
  const _CustodianReferenceData({
    required this.countries,
    required this.exchanges,
  });

  final List<CountryListItem> countries;
  final List<ExchangeListItem> exchanges;
}

class CustodianDataModule extends StatefulWidget {
  const CustodianDataModule({
    required this.mobileMode,
    required this.enabled,
    required this.menuEnableCallback,
    super.key,
  });

  final bool mobileMode;
  final bool enabled;

  final ValueChanged<bool> menuEnableCallback;

  @override
  State<CustodianDataModule> createState() => _DataModuleState();
}

class _DataModuleState extends State<CustodianDataModule> {
  CustodianListItem? _selectedListItem;

  void onItemSelected(CustodianListItem? item) {
    if (item != null) {
      if ((_selectedListItem == null) || (_selectedListItem!.id != item.id)) {
        setState(() {
          _selectedListItem = item;
        });
      }
    } else {
      if (_selectedListItem != null) {
        setState(() {
          _selectedListItem = null;
        });
      }
    }
  }

  bool _createMode = false;

  void onCreateMode(bool newCreateMode) {
    if (_createMode != newCreateMode) {
      setState(() {
        _createMode = newCreateMode;
      });

      widget.menuEnableCallback(!newCreateMode);
    }
  }

  //----------------------------------------------------------------------------

  final _createNotifier = ValueNotifier<CustodianListItem?>(null);
  final _updateNotifier = ValueNotifier<CustodianListItem?>(null);
  final _deleteNotifier = ValueNotifier<CustodianListItem?>(null);

  //----------------------------------------------------------------------------

  late Future<_CustodianReferenceData> _referenceDataFuture;

  Future<_CustodianReferenceData> _readReferenceData() async {
    final openapi = Openapi();

    openapi.dio.options.connectTimeout = const Duration(seconds: 10);
    openapi.dio.options.receiveTimeout = const Duration(seconds: 15);
    // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

    final results = await Future.wait<Object>([
      openapi.getCountryApi().getCountries().then(
        (response) => response.data?.toList() ?? const <CountryListItem>[],
      ),
      openapi.getExchangeApi().getExchanges().then(
        (response) => response.data?.toList() ?? const <ExchangeListItem>[],
      ),
    ]);

    return _CustodianReferenceData(
      countries: results[0] as List<CountryListItem>,
      exchanges: results[1] as List<ExchangeListItem>,
    );
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _referenceDataFuture = _readReferenceData();
  }

  @override
  void dispose() {
    _deleteNotifier.dispose();
    _updateNotifier.dispose();
    _createNotifier.dispose();

    super.dispose();
  }

  //----------------------------------------------------------------------------

  MasterDetail newMasterDetail(_CustodianReferenceData referenceData) {
    return MasterDetail(
      mobileMode: widget.mobileMode,
      createMode: _createMode,
      listItem: _selectedListItem,
      countries: referenceData.countries,
      exchanges: referenceData.exchanges,
      itemCreatedCallback: (item) {
        onCreateMode(false);

        if (widget.mobileMode) {
          Navigator.pop(context);
        }

        _createNotifier.value = item; // Info to list
      },
      itemUpdatedCallback: (item) {
        _updateNotifier.value = item; // Info to list
      },
      itemDeletedCallback: (item) {
        if (widget.mobileMode) {
          Navigator.pop(context);
        }

        _deleteNotifier.value = item; // Info to list
      },
    );
  }

  void pushMasterDetail(_CustodianReferenceData referenceData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return newMasterDetail(referenceData);
        },
      ),
    );
  }

  void retryReferenceData() {
    setState(() {
      _referenceDataFuture = _readReferenceData();
    });
  }

  Widget _buildReferenceDataMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: retryReferenceData,
              icon: const Icon(Icons.refresh),
              label: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedModule(_CustodianReferenceData referenceData) {
    if (widget.mobileMode) {
      return Row(
        children: [
          Expanded(
            child: MasterList(
              mobileMode: widget.mobileMode,
              enabled: widget.enabled,
              selectedListItem: _selectedListItem,
              itemSelectedCallback: (item, isManual) {
                onItemSelected(item);

                if (isManual) pushMasterDetail(referenceData);
              },
              newItemCallback: () {
                onCreateMode(true);

                pushMasterDetail(referenceData);
              },
              createNotifier: _createNotifier,
              updateNotifier: _updateNotifier,
              deleteNotifier: _deleteNotifier,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: MasterList(
              mobileMode: widget.mobileMode,
              enabled: widget.enabled,
              selectedListItem: _selectedListItem,
              itemSelectedCallback: (item, _) {
                onItemSelected(item);
              },
              newItemCallback: () {
                onCreateMode(true);
              },
              createNotifier: _createNotifier,
              updateNotifier: _updateNotifier,
              deleteNotifier: _deleteNotifier,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(flex: 4, child: newMasterDetail(referenceData)),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_CustodianReferenceData>(
      future: _referenceDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildReferenceDataMessage(
            'Länder und Börsen konnten nicht geladen werden.',
          );
        }

        final referenceData = snapshot.data;
        if (referenceData == null) {
          return _buildReferenceDataMessage(
            'Länder und Börsen konnten nicht geladen werden.',
          );
        }

        if (referenceData.countries.isEmpty ||
            referenceData.exchanges.isEmpty) {
          return _buildReferenceDataMessage(
            'Die Länder- oder Börsenliste ist leer. Das Lagerstellen-Modul kann '
            'erst verwendet werden, wenn beide Listen Einträge enthalten.',
          );
        }

        return _buildLoadedModule(referenceData);
      },
    );
  }
}
