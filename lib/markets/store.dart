import 'package:flutter/foundation.dart';

import 'package:crypto_app/data_source/data_source.dart';

import './actions.dart';


class MarketsPageState {
  final List<String> availableCurrencies;
  final int page;

  MarketsPageState({
    @required this.availableCurrencies,
    @required this.page,
  });

  MarketsPageState.initialState():
        page = 0,
        availableCurrencies = Currency.availableCurrencies();
}

MarketsPageState marketsPageReducer(MarketsPageState state, action) {
  return MarketsPageState(
    availableCurrencies: Currency.availableCurrencies(),
    page: _pageReducer(state.page, action),
  );
}

int _pageReducer(int state, action) {

  if (action is MarketsChangePageAction) {
    return action.page;
  }
  return state;
}