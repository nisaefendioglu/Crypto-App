import 'package:flutter/foundation.dart';

import 'package:crypto_app/markets/markets.dart';
import 'package:crypto_app/coin_details/coin_details.dart';
import 'package:crypto_app/data_source/data_source.dart';

import './actions.dart';

class AppState {
  final String currency;
  final MarketsPageState marketsPageState;
  final DetailsPageState detailsPageState;
  final DataSourceState dataSourceState;

  AppState({
    @required this.currency,
    @required this.marketsPageState,
    @required this.detailsPageState,
    @required this.dataSourceState,
  });

  AppState.initialState()
      : currency = 'TRY',
        marketsPageState = MarketsPageState.initialState(),
        detailsPageState = DetailsPageState.initialState(),
        dataSourceState = DataSourceState.initialState();
}

AppState appStateReducer(AppState state, action) {
  return AppState(
    currency: currencyReducer(state.currency, action),
    marketsPageState: marketsPageReducer(state.marketsPageState, action),
    detailsPageState: detailsPageReducer(state.detailsPageState, action),
    dataSourceState: dataSourceStateReducer(state.dataSourceState, action)
  );
}

String currencyReducer(String state, action) {
  if (action is ChangeCurrencyAction) {
    return action.currency;
  }
  return state;
}
