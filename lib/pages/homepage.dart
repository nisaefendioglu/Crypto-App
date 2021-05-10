import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:crypto_app/models/coin_graphic.dart';
import 'package:crypto_app/pages/chat.dart';
import 'package:crypto_app/pages/profile.dart';
import 'package:crypto_app/services/authorization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final _scrollController = ScrollController();
  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Anasayfa", Colors.blue),
    new TabItem(Icons.analytics, "Analiz", Colors.blueGrey),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
    String activeUserId =
        Provider.of<AuthorizationService>(context, listen: false).activeUserId;
    Color selectedColor = tabItems[seciliPozisyon].color;
    switch (seciliPozisyon) {
      case 0:
        return HomeScreen();
        break;
      case 1:
        return CoinGraphic();
        break;
      case 2:
        return FriendlyChatApp();
        break;
      case 3:
        return Profile(
          profileId: activeUserId,
        );
        break;
    }
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
