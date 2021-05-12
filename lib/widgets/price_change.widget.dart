import 'package:flutter/material.dart';

class PriceChange extends StatelessWidget {

  final num change;
  final String price;


  const PriceChange({ Key key, this.change, this.price }): super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Row(
        children: <Widget>[
          Text(
            price == '' ? '' : price,
            style: TextStyle(
              color: change == 0 ? const Color(0xFFa2aed0) : change > 0 ? const Color(0xFFa2ea76) : const Color(0xFFff66b9),
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: <Widget>[
              Icon(
                change == 0 ? Icons.trending_flat : change > 0 ? Icons.trending_up : Icons.trending_down,
                color: change == 0 ? const Color(0xFFa2aed0) : change > 0 ? const Color(0xFFa2ea76) : const Color(0xFFff66b9),
              ),
            ],
          ),
        ],
      ),
    );
  }

}