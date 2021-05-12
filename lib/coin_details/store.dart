import 'package:flutter/foundation.dart';

import 'package:crypto_app/data_source/data_source.dart';
import 'package:crypto_app/core/core.dart';

import './actions.dart';
import './model.dart';

class DetailsPageState {
  static final Map<TimeRange, String> _timeRangeTranslation = {
    TimeRange.OneHour: '1 SAAT',
    TimeRange.SixHour: '6 SAAT',
    TimeRange.TwelveHour: '12 SAAT',
    TimeRange.OneDay: '1 GUN',
    TimeRange.OneWeek: '1 HAFTA',
    TimeRange.OneMonth: '1 AY',
    TimeRange.ThreeMonth: '3 AY',
    TimeRange.SixMonth: '6 AY',
    TimeRange.OneYear: '1 YIL'
  };

  final DetailsModel details;
  final Map<TimeRange, String> timeRangeTranslation;
  final List<TimeRange> histogramTimeRange;
  final TimeRange activeHistogramRange;

  DetailsPageState({
    @required this.details,
    @required this.timeRangeTranslation,
    @required this.histogramTimeRange,
    @required this.activeHistogramRange,
  });

  DetailsPageState.initialState()
      : details = DetailsModel(
          coinInformation: CoinInformation(
              formattedPriceChange: '',
              priceChange: 0,
              formattedPrice: '',
              name: '',
              imageUrl: '',
              fullName: ''),
        ),
        timeRangeTranslation = Map.of(_timeRangeTranslation),
        histogramTimeRange = Map.of(_timeRangeTranslation).keys.toList(),
        activeHistogramRange = TimeRange.OneDay;
}

DetailsPageState detailsPageReducer(DetailsPageState state, action) {
  return DetailsPageState(
    details: _detailsReducer(state.details, action),
    activeHistogramRange:
        _histogramTimeRangeReducer(state.activeHistogramRange, action),
    histogramTimeRange: state.histogramTimeRange,
    timeRangeTranslation: state.timeRangeTranslation,
  );
}

TimeRange _histogramTimeRangeReducer(TimeRange state, action) {
  if (action is DetailsHistogramTimeRange) {
    return action.timeRange;
  }
  return state;
}

DetailsModel _detailsReducer(DetailsModel state, action) {
  if (action is NavigationChangeToDetailsPageAction) {
    return DetailsModel(
      coinInformation: action.coinInformation,
    );
  }
  if (action is DetailsUpdate) {
    return action.details;
  }
  return state;
}
