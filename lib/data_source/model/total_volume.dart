import 'package:flutter/foundation.dart';

import 'coin_info.dart';

class TotalVolume {
  final CoinInfo coinInfo;

  TotalVolume({
    @required this.coinInfo
  });

  factory TotalVolume.fromJson(dynamic json) {

    final coinInfo = json['CoinInfo'];

    return TotalVolume(
      coinInfo: CoinInfo(
        name: coinInfo['Name'],
        imageUrl: 'https://www.cryptocompare.com${coinInfo['ImageUrl']}',
        fullName: coinInfo['FullName'],
      ),
    );
  }
}