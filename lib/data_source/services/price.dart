import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import './../model/model.dart';

import './util.dart';
import './uri.dart';

class PriceService {

  final UriService uriService = UriService();
  final http.Client client;

  PriceService({
    @required this.client
  });

  Future<MultipleSymbols> _priceMultiFull(List<dynamic> coins, Currency currency) async {
    final queryParameters = {
      'fsyms' : coins.join(','),
      'tsyms': currency.currencyCode()
    };
    final response = await client.get(uriService.priceMultiFull(queryParameters));
    final defaultModel = {
      'RAW': {},
      'DISPLAY': {}
    };

    return MultipleSymbols.fromJson(response.statusCode != 200 ? defaultModel :
    UtilService.parsedOrDefault(response.body, defaultModel));
  }

  Future<MultipleSymbols> multipleSymbolsFullData(List<dynamic> coins, Currency currency) async {

    final coinsPartition = UtilService.partition(coins, 65);

    return Future.wait(coinsPartition.map((c) => _priceMultiFull(c, currency)))
      .then((List<MultipleSymbols> responses) {
        final model = MultipleSymbols.fromJson({
          'RAW': {},
          'DISPLAY': {}
        });

        responses.forEach((MultipleSymbols response) {

          model.raw.addAll(response.raw);
          model.display.addAll(response.display);
        });

        return model;
    })
    .catchError((e) {

      return MultipleSymbols.fromJson({
        'RAW': {},
        'DISPLAY': {}
      });
    });
  }
}