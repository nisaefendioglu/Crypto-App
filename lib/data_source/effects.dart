import 'package:redux/redux.dart';
import 'package:async/async.dart';
import 'package:crypto_app/core/core.dart';
import 'package:http/http.dart' as http;

import './services/services.dart';
import './actions.dart';
import './model/model.dart';

List<Middleware<AppState>> dataSourceEffects() {
  return [
    TypedMiddleware<AppState, VolumeWithPricesAction>(_VolumeWithPricesEffects()),
    TypedMiddleware<AppState, HistogramTimeRangeAction>(_HistogramTimeRangeEffects())
  ];
}

class _VolumeWithPricesEffects implements MiddlewareClass<AppState> {

  CancelableOperation<dynamic> _dataOperation;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    _dataOperation?.cancel();

    final page = action.page;
    final currency = action.currency;

    store.dispatch(LoadingAction(serviceType: ServicesType.Volume));
    _dataOperation = CancelableOperation.fromFuture(
        TopListsService(client: http.Client()).totalVolume(currency, page: page)
            .then((volume) {

          store.dispatch(SuccessAction(serviceType: ServicesType.Volume, response: volume));
          store.dispatch(LoadingAction(serviceType: ServicesType.Prices));
          final coins = volume.map((TotalVolume tv) => tv.coinInfo.name).toList();
          return PriceService(client: http.Client()).multipleSymbolsFullData(coins, currency)
              .then((prices) {
            store.dispatch(SuccessAction(
                serviceType: ServicesType.Prices, response: prices));
          })
              .catchError((e) => store.dispatch(ErrorAction(serviceType: ServicesType.Prices)));
        })
            .catchError((e) => store.dispatch(ErrorAction(serviceType: ServicesType.Volume)))
    );
  }

}

class _HistogramTimeRangeEffects implements MiddlewareClass<AppState> {

  CancelableOperation<dynamic> _dataOperation;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    _dataOperation?.cancel();

    final timeRange = action.timeRange;
    final currency = action.currency;
    final cryptoCoin = action.cryptoCoin;
    store.dispatch(LoadingAction(serviceType: ServicesType.Histogram));
    _dataOperation = CancelableOperation.fromFuture(
        HistogramService.OHLCV(timeRange, currency, cryptoCoin)
            .then((data) {
          store.dispatch(SuccessAction(
              serviceType: ServicesType.Histogram, response: data));
        }).catchError((e) => store.dispatch(ErrorAction(serviceType: ServicesType.Histogram)))
    );
  }

}
