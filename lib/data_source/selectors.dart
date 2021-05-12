import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto_app/core/core.dart';

import './model/model.dart';
import './store.dart';

class DataSourceSelectors {
  final Store<AppState> store;

  DataSourceSelectors({
    @required this.store,
  });

  ServiceDataSourceState<List<TotalVolume>> volume() => this.store.state.dataSourceState.volume;
  ServiceDataSourceState<MultipleSymbols> prices() => this.store.state.dataSourceState.prices;
  ServiceDataSourceState<List<HistogramDataModel>> histogram() => this.store.state.dataSourceState.histogram;
}