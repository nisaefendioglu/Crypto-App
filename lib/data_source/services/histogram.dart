import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import './../model/model.dart';

import './util.dart';
import './uri.dart';

class HistogramService {

  final UriService uriService = UriService();
  final http.Client client;

  HistogramService({
    @required this.client
  });

  static Future<List<HistogramDataModel>> OHLCV(TimeRange range, String currency, String cryptoCoin) async {
    var service = HistogramService(client: http.Client());
    var configuration  = service.configuration(range);
    var method = configuration.method;
    var limit = configuration.limit;
    var aggregate = configuration.aggregate;
    return await method(Currency.fromCurrencyCode(currency), cryptoCoin, limit, aggregate);
  }

  Future<List<HistogramDataModel>> _ohlcv(HistogramServiceType serviceType, Currency currency, String coin, int limit, int aggregate) async {

    final queryParameters = {
      'fsym': coin,
      'tsym': currency.currencyCode(),
      'limit': limit.toString(),
      'aggregate': aggregate.toString()
    };

    final response = await client.get(uriService.histogram(serviceType, queryParameters));
    final Map<String, dynamic> defaultModel = {
      'Data': []
    };

    return response.statusCode != 200 ? [] :
    UtilService.parsedOrDefault(response.body, defaultModel)
    ['Data']
        .map<HistogramDataModel>((item) => HistogramDataModel.fromJson(item))
        .toList();
  }

  Future<List<HistogramDataModel>> daily(Currency currency, String coin, int limit, int aggregate) async {

    return await _ohlcv(HistogramServiceType.Day, currency, coin, limit, aggregate);
  }

  Future<List<HistogramDataModel>> hourly(Currency currency, String coin, int limit, int aggregate) async {

    return await _ohlcv(HistogramServiceType.Hour, currency, coin, limit, aggregate);
  }

  Future<List<HistogramDataModel>> minute(Currency currency, String coin, int limit, int aggregate) async {

    return await _ohlcv(HistogramServiceType.Minute, currency, coin, limit, aggregate);
  }

  _HistogramConfigurationParameters configuration(TimeRange range) {
    var conf = {
      TimeRange.OneHour: _HistogramConfigurationParameters(
        method: minute,
        limit: 60,
        aggregate: 1,
      ),
      TimeRange.SixHour: _HistogramConfigurationParameters(
        method: minute,
        limit: 360,
        aggregate: 1,
      ),
      TimeRange.TwelveHour: _HistogramConfigurationParameters(
        method: minute,
        limit: 720,
        aggregate: 1,
      ),
      TimeRange.OneDay: _HistogramConfigurationParameters(
        method: minute,
        limit: 144,
        aggregate: 10,
      ),
      TimeRange.OneWeek: _HistogramConfigurationParameters(
        method: hourly,
        limit: 168,
        aggregate: 1,
      ),
      TimeRange.OneMonth: _HistogramConfigurationParameters(
        method: hourly,
        limit: 120,
        aggregate: 6,
      ),
      TimeRange.ThreeMonth: _HistogramConfigurationParameters(
        method: daily,
        limit: 90,
        aggregate: 1,
      ),
      TimeRange.SixMonth: _HistogramConfigurationParameters(
        method: daily,
        limit: 180,
        aggregate: 1,
      ),
      TimeRange.OneYear: _HistogramConfigurationParameters(
        method: daily,
        limit: 121,
        aggregate: 3,
      )
    };
    return conf[range];
  }
}

enum TimeRange {
  OneHour,
  SixHour,
  TwelveHour,
  OneDay,
  OneWeek,
  OneMonth,
  ThreeMonth,
  SixMonth,
  OneYear
}

class _HistogramConfigurationParameters {
  final Function method;
  final num limit;
  final num aggregate;

  _HistogramConfigurationParameters({
    @required this.method,
    @required this.limit,
    @required this.aggregate,
  });
}