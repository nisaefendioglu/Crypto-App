class UriService {
  static final String authority = 'min-api.cryptocompare.com';

  Uri totalVolume(Map<String, String> queryParameters) {
    return Uri.https(authority, 'data/top/totalvol', queryParameters);
  }

  Uri priceMultiFull(Map<String, String> queryParameters) {
    return Uri.https(authority, 'data/pricemultifull', queryParameters);
  }

  Uri histogram(HistogramServiceType histogramServiceType,
      Map<String, String> queryParameters) {
    final histogramType = {
      HistogramServiceType.Day: 'day',
      HistogramServiceType.Hour: 'hour',
      HistogramServiceType.Minute: 'minute'
    }[histogramServiceType];
    return Uri.https(authority, 'data/histo' + histogramType, queryParameters);
  }
}

enum HistogramServiceType { Day, Hour, Minute }
