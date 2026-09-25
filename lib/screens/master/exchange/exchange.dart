import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:rbsclone_flutter/screens/master/exchange/exchange_detail.dart';
import 'package:rbsclone_flutter/screens/master/exchange/exchange_list.dart';

//------------------------------------------------------------------------------

class ExchangeDataModule extends StatefulWidget {
  const ExchangeDataModule(this.showBoth, {super.key});

  final bool showBoth;

  @override
  State<ExchangeDataModule> createState() => _DataModuleState();
}

class _DataModuleState extends State<ExchangeDataModule> {
  ExchangeListItem? _selectedListItem;

  void onItemSelected(ExchangeListItem? item) {
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

  final _createNotifier = ValueNotifier<ExchangeListItem?>(null);

  void onItemCreated(ExchangeListItem? item) {
    _createNotifier.value = item;
  }

  //----------------------------------------------------------------------------

  final _updateNotifier = ValueNotifier<ExchangeListItem?>(null);

  void onItemUpdated(ExchangeListItem? item) {
    _updateNotifier.value = item;
  }

  //----------------------------------------------------------------------------

  final _deleteNotifier = ValueNotifier<ExchangeListItem?>(null);

  void onItemDeleted(ExchangeListItem? item) {
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
