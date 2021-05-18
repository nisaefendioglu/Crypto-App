import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app/widgets/price_change.widget.dart';

typedef void SelectedCoinTileCallback(SelectedCoinTile selectedCoinTile);

class CoinListTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String fullName;
  final String formattedPrice;
  final num priceChange;
  final String formattedPriceChange;
  final SelectedCoinTileCallback onSelect;
  final BorderRadiusGeometry borderRadius;

  const CoinListTile({
    Key key,
    this.imageUrl = '',
    this.name = '',
    this.fullName = '',
    this.formattedPrice = '',
    this.priceChange = 0,
    this.formattedPriceChange = '',
    this.borderRadius,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: borderRadius ?? BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 30.0,
              ),
              onTap: () {
                this.onSelect(SelectedCoinTile(
                  fullName: fullName,
                  imageUrl: imageUrl,
                  name: name,
                  formattedPrice: formattedPrice,
                  priceChange: priceChange,
                  formattedPriceChange: formattedPriceChange,
                ));
              },
              title: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      formattedPrice,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    PriceChange(
                      change: priceChange,
                      price: formattedPriceChange,
                    ),
                  ],
                ),
                Text(
                  " "
                  "Detay →",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedCoinTile {
  final String imageUrl;
  final String name;
  final String fullName;
  final String formattedPrice;
  final num priceChange;
  final String formattedPriceChange;

  SelectedCoinTile(
      {this.imageUrl,
      this.name,
      this.fullName,
      this.formattedPrice,
      this.priceChange,
      this.formattedPriceChange});
}
