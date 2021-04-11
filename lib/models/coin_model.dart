import 'dart:convert';
import 'package:http/http.dart' as http;
const List<String> cryptoList = [
  'bitcoin',
  'ethereum',
  'litecoin',
  'polkadot',
  'bitcoin-cash',
  'stellar',
  'chainlink',
  'binancecoin',
  'tether',
  'monero',
];

const coinAPIURL = 'https://api.coingecko.com/api/v3/simple/price?ids=';

const apiKey = '';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String priceUnit = selectedCurrency.toLowerCase();
      String requestURL = '$coinAPIURL$crypto&vs_currencies=$priceUnit';
      //'$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      http.Response response = await http.get(requestURL);
      if (response.statusCode == 200) {
        String data = response.body;
        //var decodedData = jsonDecode(response.body);
        var price = jsonDecode(data)['$crypto']['$priceUnit'];
        cryptoPrices[crypto] = price.toString();
        print(cryptoPrices);
      } else {
        print(response.statusCode);
        throw 'İstek atılırken bir sorun oluştu.';
      }
    }
    return cryptoPrices;
  }
}
