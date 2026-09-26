import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:rbsclone_flutter/screens/master/custodian/custodian_detail.dart';
import 'package:rbsclone_flutter/screens/master/custodian/custodian_list.dart';

//------------------------------------------------------------------------------

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
  void dispose() {
    _deleteNotifier.dispose();
    _updateNotifier.dispose();
    _createNotifier.dispose();

    super.dispose();
  }

  //----------------------------------------------------------------------------

  MasterDetail newMasterDetail() {
    return MasterDetail(
      mobileMode: widget.mobileMode,
      createMode: _createMode,
      listItem: _selectedListItem,
      countries: _countries,
      itemCreatedCallback: (item) {
        _createNotifier.value = item; // Info to list
      },
      itemUpdatedCallback: (item) {
        _updateNotifier.value = item; // Info to list

        onCreateMode(false);

        if (widget.mobileMode) {
          Navigator.pop(context);
        }
      },
      itemDeletedCallback: (item) {
        _deleteNotifier.value = item; // Info to list
      },
    );
  }

  void pushMasterDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return newMasterDetail();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mobileMode) {
      return Row(
        children: [
          Expanded(
            child: MasterList(
              mobileMode: widget.mobileMode,
              enabled: widget.enabled,
              selectedListItem: _selectedListItem,
              itemSelectedCallback: (item) {
                onItemSelected(item);

                pushMasterDetail();
              },
              newItemCallback: () {
                onCreateMode(true);

                pushMasterDetail();
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
              itemSelectedCallback: onItemSelected,
              newItemCallback: () {
                onCreateMode(true);
              },
              createNotifier: _createNotifier,
              updateNotifier: _updateNotifier,
              deleteNotifier: _deleteNotifier,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(flex: 3, child: newMasterDetail()),
        ],
      );
    }
  }
}
