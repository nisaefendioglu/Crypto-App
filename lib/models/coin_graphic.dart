import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    CoinGraphic(),
  );
}

class CoinGraphic extends StatelessWidget {
  const CoinGraphic({
    Key key,
  }) : super(key: key);

  static const coinAPIURL =
      'https://api.coingecko.com/api/v3/coins/kripto/market_chart/range?vs_currency=usd&from=1392577232&to=1392577232';

  @override
  Widget build(BuildContext context) {}
}
