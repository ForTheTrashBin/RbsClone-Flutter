import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

//------------------------------------------------------------------------------

class MasterList extends StatefulWidget {
  const MasterList({
    required this.mobileMode,
    required this.enabled,
    required this.selectedListItem,
    required this.itemSelectedCallback,
    required this.newCallback,
    required this.createNotifier,
    required this.updateNotifier,
    required this.deleteNotifier,
    super.key,
  });

  final bool mobileMode;
  final bool enabled;

  final CustodianListItem? selectedListItem;

  final ValueChanged<CustodianListItem?> itemSelectedCallback;

  final VoidCallback newCallback;

  final ValueNotifier<CustodianListItem?> createNotifier;
  final ValueNotifier<CustodianListItem?> updateNotifier;
  final ValueNotifier<CustodianListItem?> deleteNotifier;

  @override
  State<MasterList> createState() => _MasterListState();
}

class _MasterListState extends State<MasterList> {
  List<CustodianListItem> _entriesAll = [];
  List<CustodianListItem> _entriesFiltered = [];

  final ItemScrollController _itemScrollController = ItemScrollController();

  late Future<List<CustodianListItem>> _dbFuture;

  late TextEditingController _searchController;

  Future<List<CustodianListItem>> fetchListData() async {
    final openapi = Openapi();

    openapi.dio.options.connectTimeout = const Duration(seconds: 10);
    openapi.dio.options.receiveTimeout = const Duration(seconds: 15);
    // openapi.dio.options.sendTimeout = const Duration(seconds: 5);

    final responseFuture = openapi.getCustodianApi().getCustodians();

    final minWaitFuture = Future.delayed(Duration(milliseconds: 600));

    final waitGroup = await Future.wait([responseFuture, minWaitFuture]);

    final response = waitGroup[0];

    return response.data?.toList() ?? const <CustodianListItem>[];
  }

  void _onRefresh() {
    setState(() {
      _entriesAll = [];
      _entriesFiltered = [];

      _searchController.clear();

      widget.itemSelectedCallback(null);

      _dbFuture = fetchListData();
    });
  }

  //----------------------------------------------------------------------------

  void _filterListe(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _entriesFiltered = _entriesAll;
      } else {
        _entriesFiltered = _entriesAll.where((entry) {
          String searchTextLower = searchText.toLowerCase();

          return entry.shortcode.toLowerCase().contains(searchTextLower) ||
              entry.name.toLowerCase().contains(searchTextLower);
        }).toList();
      }
    });
  }

  //----------------------------------------------------------------------------

  void _onDataCreated() {
    print("***************************** _MasterListState::_onDataCreated");
  }

  void _scrollToItem(String id) {
    final index = _entriesFiltered.indexWhere((entry) {
      return entry.id == id;
    });

    if (index >= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_itemScrollController.isAttached) {
          _itemScrollController.scrollTo(
            index: index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.1,
          );
        }
      });
    }
  }

  void _onDataUpdated() {
    final listItem = widget.updateNotifier.value;

    if (listItem != null) {
      final indexAll = _entriesAll.indexWhere((entry) {
        return entry.id == listItem.id;
      });

      final indexFiltered = _entriesFiltered.indexWhere((entry) {
        return entry.id == listItem.id;
      });

      if ((indexAll >= 0) && (indexFiltered >= 0)) {
        bool needSort =
            ((_entriesAll[indexAll].shortcode != listItem.shortcode) ||
            (_entriesFiltered[indexFiltered].shortcode != listItem.shortcode));

        setState(() {
          _entriesAll[indexAll] = listItem;
          _entriesFiltered[indexFiltered] = listItem;

          if (needSort) {
            _entriesAll.sort((a, b) {
              return a.shortcode.toUpperCase().compareTo(
                b.shortcode.toUpperCase(),
              );
            });

            _entriesFiltered.sort((a, b) {
              return a.shortcode.toUpperCase().compareTo(
                b.shortcode.toUpperCase(),
              );
            });
          }
        });

        if (needSort) {
          _scrollToItem(listItem.id);
        }
      }
    } else {
      _onRefresh();
    }
  }

  void _onDataDeleted() {
    final listItem = widget.deleteNotifier.value;

    if (listItem != null) {
      final indexAll = _entriesAll.indexWhere((entry) {
        return entry.id == listItem.id;
      });

      final indexFiltered = _entriesFiltered.indexWhere((entry) {
        return entry.id == listItem.id;
      });

      if ((indexAll >= 0) && (indexFiltered >= 0)) {
        setState(() {
          _entriesAll.removeAt(indexAll);
          _entriesFiltered.removeAt(indexFiltered);
        });
      }
    }
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _dbFuture = fetchListData();

    _searchController = TextEditingController();

    widget.createNotifier.addListener(_onDataCreated);
    widget.updateNotifier.addListener(_onDataUpdated);
    widget.deleteNotifier.addListener(_onDataDeleted);
  }

  @override
  void dispose() {
    _searchController.dispose();

    widget.deleteNotifier.removeListener(_onDataDeleted);
    widget.updateNotifier.removeListener(_onDataUpdated);
    widget.createNotifier.removeListener(_onDataCreated);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: !widget.enabled,
          child: Scaffold(
            floatingActionButton: widget.enabled
                ? FloatingActionButton.extended(
                    onPressed: widget.newCallback,
                    label: const Text("Neu"),
                    icon: const Icon(Icons.add),
                  )
                : null,
            body: FutureBuilder<List<CustodianListItem>>(
              future: _dbFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Fehler: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  if (_entriesAll.isEmpty) {
                    _entriesAll = snapshot.data!;
                    _entriesFiltered = _entriesAll;
                  }

                  //------------------------------------------------------------------

                  if (_entriesFiltered.isNotEmpty) {
                    if (widget.selectedListItem != null) {
                      CustodianListItem? foundItem = _entriesFiltered.where((
                        entry,
                      ) {
                        return entry.id == widget.selectedListItem!.id;
                      }).firstOrNull;

                      if (foundItem == null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          widget.itemSelectedCallback(_entriesFiltered[0]);
                        });
                      }
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.itemSelectedCallback(_entriesFiltered[0]);
                      });
                    }
                  } else {
                    if (widget.selectedListItem != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.itemSelectedCallback(null);
                      });
                    }
                  }

                  //------------------------------------------------------------------

                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: [
                        //------------------------------------------------------------
                        // Count & search
                        //------------------------------------------------------------
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 12.0,
                            bottom: 12.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${_entriesFiltered.length}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: _filterListe,
                                  decoration: InputDecoration(
                                    hintText: "Suchen...",
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon:
                                        _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(Icons.clear, size: 20),
                                            onPressed: () {
                                              _searchController.clear();
                                              _filterListe("");
                                            },
                                          )
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                onPressed: _onRefresh,
                              ),
                            ],
                          ),
                        ),
                        //------------------------------------------------------------
                        // List of items or message, if list is empty
                        //------------------------------------------------------------
                        Expanded(
                          child: ClipRect(
                            child: _entriesFiltered.isEmpty
                                ? const Center(
                                    child: Text(
                                      "Keine Lagerstellen vorhanden.",
                                    ),
                                  )
                                : ScrollablePositionedList.separated(
                                    itemCount: _entriesFiltered.length,
                                    itemScrollController: _itemScrollController,
                                    separatorBuilder: (_, _) =>
                                        const Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final listItem = _entriesFiltered[index];
                                      final isSelected =
                                          widget.enabled &&
                                          (widget.selectedListItem?.id ==
                                              listItem.id);
                                      return ListTile(
                                        key: ValueKey(listItem.id),
                                        leading: CircleAvatar(
                                          child: Text(
                                            listItem.shortcode
                                                .substring(0, 1)
                                                .toUpperCase(),
                                          ),
                                        ),
                                        title: Text(listItem.shortcode),
                                        subtitle: Text(listItem.name),
                                        trailing: widget.mobileMode
                                            ? const Icon(Icons.chevron_right)
                                            : null,
                                        selected: isSelected,
                                        selectedTileColor: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer
                                            .withValues(alpha: 0.55),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        onTap: () {
                                          widget.itemSelectedCallback(listItem);
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),

        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 246),
              curve: Curves.fastOutSlowIn,
              color: widget.enabled
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.scrim.withValues(alpha: 0.35),
            ),
          ),
        ),
      ],
    );
  }
}
