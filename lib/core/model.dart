import 'package:flutter/foundation.dart';

class CoinInformation {
  final String imageUrl;
  final String name;
  final String fullName;
  final String formattedPrice;
  final num priceChange;
  final String formattedPriceChange;

  CoinInformation(
      {@required this.imageUrl,
      @required this.name,
      @required this.fullName,
      @required this.formattedPrice,
      @required this.priceChange,
      @required this.formattedPriceChange})
      : assert(imageUrl != null),
        assert(name != null),
        assert(fullName != null),
        assert(formattedPrice != null),
        assert(priceChange != null),
        assert(formattedPriceChange != null);
}
