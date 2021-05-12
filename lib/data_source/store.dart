import 'package:flutter/foundation.dart';
import './model/model.dart';
import './actions.dart';



class ServiceDataSourceState<T> {
  final T response;
  final ServiceDataState state;

  ServiceDataSourceState({
    @required this.response,
    @required this.state,
  });
}

class DataSourceState {
  final ServiceDataSourceState<List<TotalVolume>> volume;
  final ServiceDataSourceState<MultipleSymbols> prices;
  final ServiceDataSourceState<List<HistogramDataModel>> histogram;

  DataSourceState({
    @required this.volume,
    @required this.prices,
    @required this.histogram,
  });

  DataSourceState.initialState():
    volume = ServiceDataSourceState<List<TotalVolume>>(
      response: List.unmodifiable([]),
      state: ServiceDataState.Success
    ),
    prices = ServiceDataSourceState<MultipleSymbols>(
      response: MultipleSymbols(raw: Map.identity(), display: Map.identity()),
      state: ServiceDataState.Success
    ),
    histogram = ServiceDataSourceState<List<HistogramDataModel>>(
      response: List.unmodifiable([]),
      state: ServiceDataState.Success
    );
}

DataSourceState dataSourceStateReducer(DataSourceState state, action) {
  return DataSourceState(
    prices: _pricesReducer(state.prices, action),
    volume: _volumeReducer(state.volume, action),
    histogram: _histogramReducer(state.histogram, action),
  );
}

ServiceDataSourceState<List<TotalVolume>> _volumeReducer(ServiceDataSourceState<List<TotalVolume>> state, action) {

  if (action is SuccessAction && action.serviceType == ServicesType.Volume) {
    return ServiceDataSourceState<List<TotalVolume>>(
      state: action.state,
      response: List.unmodifiable(action.response)
    );
  }

  if (
    (action is ErrorAction && action.serviceType == ServicesType.Volume) ||
    (action is LoadingAction && action.serviceType == ServicesType.Volume)
  ) {
    return ServiceDataSourceState<List<TotalVolume>>(
        state: action.state,
        response: List.unmodifiable([])
    );
  }
  return state;
}

ServiceDataSourceState<MultipleSymbols> _pricesReducer(ServiceDataSourceState<MultipleSymbols> state, action) {

  if (action is SuccessAction && action.serviceType == ServicesType.Prices) {
    return ServiceDataSourceState<MultipleSymbols>(
      state: action.state,
      response: action.response
    );
  }

  if (
    (action is ErrorAction && action.serviceType == ServicesType.Prices) ||
    (action is LoadingAction && action.serviceType == ServicesType.Prices)
  ) {
    return ServiceDataSourceState<MultipleSymbols>(
      state: action.state,
      response: MultipleSymbols(raw: Map.identity(), display: Map.identity())
    );
  }
  return state;
}

ServiceDataSourceState<List<HistogramDataModel>> _histogramReducer(ServiceDataSourceState<List<HistogramDataModel>> state, action) {

  if (action is SuccessAction && action.serviceType == ServicesType.Histogram) {
    return ServiceDataSourceState<List<HistogramDataModel>>(
      state: action.state,
      response: List.unmodifiable(action.response)
    );
  }

  if (
    (action is ErrorAction && action.serviceType == ServicesType.Histogram) ||
    (action is LoadingAction && action.serviceType == ServicesType.Histogram)
  ) {
    return ServiceDataSourceState<List<HistogramDataModel>>(
      state: action.state,
      response: List.unmodifiable([])
    );
  }
  return state;
}



