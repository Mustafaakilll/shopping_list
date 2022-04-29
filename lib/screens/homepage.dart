import 'package:flutter/material.dart';
import 'package:shopping_list/screens/shopping_list_page.dart';
import 'package:shopping_list/services/advert-services.dart';

import 'history_page.dart';
import 'main_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final AdvertService _advertService = AdvertService();

  @override
  void initState() {
    _pageController.addListener(() {
      int _currentIndex = _pageController.page.round();
      if (_currentIndex != _selectedIndex) {
        _selectedIndex = _currentIndex;
        setState(() {});
      }
    });
    _advertService.showBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home Page"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "List"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Archive")
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
      body: PageView(
        controller: _pageController,
        children: [MainPage(), ShoppingListPage(), HistoryPage()],
      ),
    );
  }

  void _onTap(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
