import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/http.dart';
import 'package:shopping_list/model/item.dart';
import 'package:shopping_list/services/advert-services.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  StreamController<List<Item>> _streamController = StreamController();
  ItemService _itemService;
  var _items = List<Item>();
  var _currentPage = 0;
  final ScrollController _scrollController = ScrollController();
  final AdvertService _advertService = AdvertService();

  @override
  void initState() {
    _itemService = ItemService();
    _fetchArchive(0);
    _scrollController.addListener(_onScrolled);
    _advertService.showIntersitial();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text("History Page"),
        ),
        Expanded(
            child: StreamBuilder<List<Item>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.data.length == 0) {
                        return Center(
                            child: Text(
                          "Your archive is empty",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ));
                      }
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = snapshot.data[index];
                          return ListTile(
                            title: Text(item.name),
                          );
                        },
                      );
                      break;
                    default:
                      return Container();
                      break;
                  }
                }))
      ],
    );
  }

  Future<void> _fetchArchive(int page) async {
    int take = 20;
    var items = await _itemService.fetchArchive(20, take * page);

    _items.addAll(items);
    if (items.length == 0) return;

    _streamController.add(_items);
  }

  void _onScrolled() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      _currentPage += 1;
      _fetchArchive(_currentPage);
    }
  }
}
