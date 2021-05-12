import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import './model.dart';

class NavigationKeys {
  static final navigationState = GlobalKey<NavigatorState>();
}

class NavigationChangeToDetailsPageAction {
  final CoinInformation coinInformation;
  NavigationChangeToDetailsPageAction({
    @required this.coinInformation
  }): assert(coinInformation != null);
}

class ChangeCurrencyAction {
  final String currency;
  ChangeCurrencyAction({
    @required this.currency
  }): assert(currency != null);
}