import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:crypto_app/pages/Block.dart';
import 'home_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final _scrollController = ScrollController();
  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Anasayfa", Colors.blue),
    new TabItem(Icons.message, "Sohbet Odası", Colors.orange),
    new TabItem(Icons.person, "Profil", Colors.red),
  ]);
  int seciliPozisyon = 0;
  CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController =
        new CircularBottomNavigationController(seciliPozisyon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        title: Text("Crypto App"),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(bottom: 60),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Color selectedColor = tabItems[seciliPozisyon].color;
    String slogan;
    switch (seciliPozisyon) {
      case 0:
        return BlockPage();
        // slogan = "Anasayfa";
        break;
      case 1:
        BlockPage();
        slogan = "Sohbet Odaları";
        break;
      case 2:
        slogan = "Profil Sayfası";
        break;
    }
    return Center(
      child: Text(slogan),
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: 60,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          seciliPozisyon = selectedPos;
        });
      },
    );
  }
}
