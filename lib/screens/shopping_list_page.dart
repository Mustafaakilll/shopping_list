import 'package:flutter/material.dart';
import 'package:shopping_list/data/http.dart';
import 'package:shopping_list/model/item.dart';
import 'package:shopping_list/screens/dialogs/item_dialog.dart';

import 'dialogs/confirm_dialog.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  ItemService _itemService;

  @override
  void initState() {
    _itemService = ItemService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text("Shopping List"),
          actions: [
            IconButton(
                icon: Icon(Icons.done),
                onPressed: () async {
                  await _itemService.addToArchive();
                  setState(() {});
                })
          ],
        ),
        Expanded(
            child: Stack(
          children: [
            FutureBuilder(
              future: _itemService.fetchItems(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
                if (snapshot.hasData && snapshot.data.length == 0) {
                  return Center(
                      child: Text(
                    "Your list is Empty",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Item item = snapshot.data[index];
                      return GestureDetector(
                        onLongPress: () async {
                          bool result = await showDialog(
                              context: context,
                              builder: (BuildContext context) => ConfirmDialog(
                                    item: item,
                                  ));
                          item.isArchived = result;
                          await _itemService.editItem(item);
                          setState(() {});
                        },
                        child: CheckboxListTile(
                          title: Text(item.name),
                          onChanged: (bool value) async {
                            item.isCompleted = !item.isCompleted;
                            await _itemService.editItem(item);
                            setState(() {});
                          },
                          value: item.isCompleted,
                        ),
                      );
                    },
                  );
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            Positioned(
              right: 50,
              bottom: 30,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  String itemName = await showDialog(
                      context: context,
                      builder: (BuildContext context) => ItemDialog());

                  if (itemName != null && itemName.isNotEmpty) {
                    var item = Item(
                        name: itemName, isCompleted: false, isArchived: false);

                    try {
                      await _itemService.addItem(item);
                      setState(() {});
                    } catch (ex) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(ex.toString())));
                    }
                  }
                },
                child: Icon(Icons.add),
              ),
            )
          ],
        ))
      ],
    );
  }
}
