import 'package:redux/redux.dart';

import 'package:crypto_app/markets/markets.dart';
import 'package:crypto_app/coin_details/coin_details.dart';
import 'package:crypto_app/data_source/data_source.dart';

import './actions.dart';
import './store.dart';

List<Middleware<AppState>> appStateMiddleware() {
  return [
    TypedMiddleware<AppState, NavigationChangeToDetailsPageAction>(
        _NavigationEffect()),
  ]..addAll(marketsEffects())..addAll(coinDetailsEffects())..addAll(dataSourceEffects());
}

class _NavigationEffect implements MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    await NavigationKeys.navigationState.currentState.pushNamed('/details');
  }
}