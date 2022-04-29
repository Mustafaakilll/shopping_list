import 'dart:convert';

import 'package:shopping_list/model/item.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/model/overview.dart';

class ItemService {
  final String _url = "kesali-shopping.herokuapp.com";

  Future<List<Item>> fetchItems() async {
    var uri = Uri.https(_url, "item");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Iterable items = json.decode(response.body);
      return items.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception("Something went Wrong");
    }
  }

  Future<Item> editItem(Item item) async {
    var uri = Uri.https(_url, "item/${item.id}");
    final response = await http.patch(uri,
        headers: {"content-type": "application/json"}, body: item.toJson());
    if (response.statusCode == 200) {
      Map item = json.decode(response.body);
      return Item.fromJson(item);
    } else {
      throw Exception("Something went Wrong!");
    }
  }

  Future<Item> addItem(Item item) async {
    var uri = Uri.https(_url, "item");
    final response = await http.post(uri,
        headers: {"content-type": "application/json"}, body: item.toJson());

    if (response.statusCode == 201) {
      Map item = json.decode(response.body);
      return Item.fromJson(item);
    } else {
      throw Exception("SomeThing went Wrong");
    }
  }

  Future<void> addToArchive() async {
    var uri = Uri.https(_url, "history");
    final response = await http.post(uri);

    if (response.statusCode != 201) {
      throw Exception("Something Went Wrong");
    }
  }

  Future<List<Item>> fetchArchive(int take, int skip) async {
    var parameters = {"take": take.toString(), "skip": skip.toString()};
    var uri = Uri.https(_url, "history", parameters);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Iterable items = json.decode(response.body);
      return items.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<OverView> overview() async {
    var uri = Uri.https(_url, "overview");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map overview = json.decode(response.body);
      return OverView.fromJson(overview);
    } else {
      throw Exception("Something went wrong");
    }
  }
}
