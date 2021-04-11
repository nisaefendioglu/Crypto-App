

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/coin_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCurrency = 'USD';

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    print('durum');

    try {
      var data = await CoinData().getCoinData(selectedCurrency);

      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '...' : coinValues[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              height: (MediaQuery.of(context).size.height) - 150.0,
              child: SingleChildScrollView(child: makeCards())),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 10,
                  blurRadius: 22,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 00.0),
            //color: Colors.lightBlue,
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
  });

  final value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 2.0),
      child: Card(
        color: Colors.black,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 01.0, horizontal: 00.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  '${cryptoCurrency[0].toUpperCase()}${cryptoCurrency.substring(1)}',
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Colors.white, fontSize: 18),
                ),
                leading: SizedBox(
                  child: Image.asset('images/$cryptoCurrency.png'),
                ),
                trailing: Text(
                  '$value $selectedCurrency',
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Colors.white, fontSize: 18),
                ),
              ),
              // Column(
              //   children: [
              //     Kspinkit,
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
