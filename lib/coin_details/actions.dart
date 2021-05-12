import 'package:flutter/foundation.dart';

import 'package:crypto_app/data_source/data_source.dart';
import './model.dart';

class DetailsUpdate {

  final DetailsModel details;

  DetailsUpdate({
    @required this.details
  }): assert(details != null);
}

class DetailsHistogramTimeRange {
  final TimeRange timeRange;

  DetailsHistogramTimeRange({
    @required this.timeRange
  }): assert(timeRange != null);
}

class DetailsHistogramRequestDataAction {}

class DetailsRefresh {}