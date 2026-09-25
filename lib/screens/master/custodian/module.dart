import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:rbsclone_flutter/screens/master/custodian/detail.dart';
import 'package:rbsclone_flutter/screens/master/custodian/list.dart';

//------------------------------------------------------------------------------

class CustodianDataModule extends StatefulWidget {
  const CustodianDataModule(this.showBoth, {super.key});

  final bool showBoth;

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

  //----------------------------------------------------------------------------

  void onNewCallback() {
    print("**************** _DataModuleState::onNewCallback");
  }

  //----------------------------------------------------------------------------

  final _createNotifier = ValueNotifier<CustodianListItem?>(null);

  void onItemCreated(CustodianListItem? item) {
    _createNotifier.value = item;
  }

  //----------------------------------------------------------------------------

  final _updateNotifier = ValueNotifier<CustodianListItem?>(null);

  void onItemUpdated(CustodianListItem? item) {
    _updateNotifier.value = item;
  }

  //----------------------------------------------------------------------------

  final _deleteNotifier = ValueNotifier<CustodianListItem?>(null);

  void onItemDeleted(CustodianListItem? item) {
    _deleteNotifier.value = item;
  }

  //----------------------------------------------------------------------------

  @override
  void dispose() {
    _deleteNotifier.dispose();
    _updateNotifier.dispose();
    _createNotifier.dispose();

    super.dispose();
  }

  //----------------------------------------------------------------------------

  List<CountryListItem> _countries = [];

  void readCountries() async {
    final api = Openapi();

    List<CountryListItem> newList = [];

    try {
      final response = await api.getCountryApi().getCountries().timeout(
        const Duration(seconds: 10),
      );

      newList = response.data?.toList() ?? const <CountryListItem>[];
    } finally {
      setState(() {
        _countries = newList;
      });
    }
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    readCountries();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showBoth) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: MasterList(
              showBoth: widget.showBoth,
              selectedListItem: _selectedListItem,
              itemSelectedCallback: onItemSelected,
              newCallback: onNewCallback,
              createNotifier: _createNotifier,
              updateNotifier: _updateNotifier,
              deleteNotifier: _deleteNotifier,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: MasterDetail(
              showBoth: widget.showBoth,
              listItem: _selectedListItem,
              countries: _countries,
              itemCreatedCallback: onItemCreated,
              itemUpdatedCallback: onItemUpdated,
              itemDeletedCallback: onItemDeleted,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: MasterList(
              showBoth: widget.showBoth,
              selectedListItem: _selectedListItem,
              itemSelectedCallback: (item) {
                onItemSelected(item);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MasterDetail(
                        showBoth: widget.showBoth,
                        listItem: _selectedListItem,
                        countries: _countries,
                        itemCreatedCallback: onItemCreated,
                        itemUpdatedCallback: onItemUpdated,
                        itemDeletedCallback: onItemDeleted,
                      );
                    },
                  ),
                );
              },
              newCallback: onNewCallback,
              createNotifier: _createNotifier,
              updateNotifier: _updateNotifier,
              deleteNotifier: _deleteNotifier,
            ),
          ),
        ],
      );
    }
  }
}
