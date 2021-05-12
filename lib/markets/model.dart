import 'package:flutter/foundation.dart';

class VolumeItemModel {

  final String name;
  final String imageUrl;
  final String fullName;
  final String price;
  final String priceChangeDisplay;
  final num priceChange;

  VolumeItemModel({
    @required this.name,
    @required this.imageUrl,
    @required this.fullName,
    @required this.price,
    @required this.priceChangeDisplay,
    @required this.priceChange,
  });
}