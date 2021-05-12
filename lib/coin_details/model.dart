import 'package:crypto_app/core/core.dart';
import 'package:flutter/foundation.dart';

class DetailsModel {
  final CoinInformation coinInformation;

  DetailsModel({
    @required this.coinInformation
  }): assert(coinInformation != null);

}