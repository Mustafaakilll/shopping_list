import 'package:flutter/material.dart';
import 'package:shopping_list/data/http.dart';
import 'package:shopping_list/model/overview.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
          title: Text("OverView"),
        ),
        FutureBuilder(
          future: _itemService.overview(),
          builder: (BuildContext context, AsyncSnapshot<OverView> snapshot) {
            if (!snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 50),
                child: CircularProgressIndicator(),
              );
            }
            return Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  BuildCard(
                    icon: Icons.shopping_basket,
                    title: "Total Items",
                    total: snapshot.data.total,
                  ),
                  BuildCard(
                    icon: Icons.shopping_cart,
                    title: "Current Items",
                    total: snapshot.data.current,
                  ),
                  BuildCard(
                    icon: Icons.history,
                    title: "Completed Items",
                    total: snapshot.data.completed,
                  ),
                  BuildCard(
                    icon: Icons.remove_shopping_cart,
                    title: "Deleted Items",
                    total: snapshot.data.deleted,
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

class BuildCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int total;

  const BuildCard({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 48,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            total.toString(),
            style: TextStyle(fontSize: 32),
          )
        ],
      ),
    );
  }
}
