import 'package:flutter/foundation.dart';
import './model/model.dart';
import './services/services.dart';

enum ServicesType {
  Volume, Prices, Histogram
}

enum ServiceDataState {
  Error, Success, Loading
}

class VolumeWithPricesAction {
  final num page;
  final Currency currency;

  VolumeWithPricesAction({
    @required this.currency,
    @required this.page,
  }):
        assert(currency != null),
        assert(page != null);
}

class HistogramTimeRangeAction {
  final TimeRange timeRange;
  final String currency;
  final String cryptoCoin;
  HistogramTimeRangeAction({
    @required this.currency,
    @required this.timeRange,
    @required this.cryptoCoin
  }):
        assert(currency != null),
        assert(timeRange != null),
        assert(cryptoCoin != null);
}

class LoadingAction {
  final ServiceDataState state = ServiceDataState.Loading;
  final ServicesType serviceType;

  LoadingAction({
    @required this.serviceType,
  });
}

class ErrorAction {
  final ServiceDataState state = ServiceDataState.Loading;
  final ServicesType serviceType;

  ErrorAction({
    @required this.serviceType,
  });
}

class SuccessAction<T> {
  final ServiceDataState state = ServiceDataState.Success;
  final ServicesType serviceType;
  final T response;

  SuccessAction({
    @required this.serviceType,
    @required this.response,
  });
}
