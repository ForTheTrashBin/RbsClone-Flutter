import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:rbsclone_flutter/screens/master/country/country_detail.dart';
import 'package:rbsclone_flutter/screens/master/country/country_list.dart';

//------------------------------------------------------------------------------

class CountryDataModule extends StatefulWidget {
  const CountryDataModule({
    required this.mobileMode,
    required this.enabled,
    required this.menuEnableCallback,
    super.key,
  });

  final bool mobileMode;
  final bool enabled;

  final ValueChanged<bool> menuEnableCallback;

  @override
  State<CountryDataModule> createState() => _DataModuleState();
}

class _DataModuleState extends State<CountryDataModule> {
  CountryListItem? _selectedListItem;

  void onItemSelected(CountryListItem? item) {
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

  final _createNotifier = ValueNotifier<CountryListItem?>(null);
  final _updateNotifier = ValueNotifier<CountryListItem?>(null);
  final _deleteNotifier = ValueNotifier<CountryListItem?>(null);

  //----------------------------------------------------------------------------

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
