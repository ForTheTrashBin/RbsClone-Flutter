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

  //----------------------------------------------------------------------------

  void onNewCallback() {
    print("**************** _DataModuleState::onNewCallback");

    widget.menuEnableCallback(false);
  }

  //----------------------------------------------------------------------------

  final _createNotifier = ValueNotifier<CountryListItem?>(null);

  void onItemCreated(CountryListItem? item) {
    _createNotifier.value = item;
  }

  //----------------------------------------------------------------------------

  final _updateNotifier = ValueNotifier<CountryListItem?>(null);

  void onItemUpdated(CountryListItem? item) {
    _updateNotifier.value = item;

    widget.menuEnableCallback(true);
  }

  //----------------------------------------------------------------------------

  final _deleteNotifier = ValueNotifier<CountryListItem?>(null);

  void onItemDeleted(CountryListItem? item) {
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

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MasterDetail(
                        mobileMode: widget.mobileMode,
                        listItem: _selectedListItem,
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
              mobileMode: widget.mobileMode,
              listItem: _selectedListItem,
              itemCreatedCallback: onItemCreated,
              itemUpdatedCallback: onItemUpdated,
              itemDeletedCallback: onItemDeleted,
            ),
          ),
        ],
      );
    }
  }
}
