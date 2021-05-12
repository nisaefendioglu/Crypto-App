import 'package:flutter/material.dart';
import 'package:crypto_app/data_source/data_source.dart';
import './time_series_chart.widget.dart';

class CoinVolumeWidget extends StatefulWidget {

  final List<HistogramDataModel> histData;

  CoinVolumeWidget({Key key, this.histData,}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CoinVolumeState(
      histData: histData,
    );
  }

}

class CoinVolumeState extends State<CoinVolumeWidget> {
  List<HistogramDataModel> histData = [];
  CoinVolumeState({this.histData});

  @override
  Widget build(BuildContext context) {
    return TimeSeriesChartWidget(
      data: histData.map((d) => ChartDataModel(time: d.time, value: d.volumeTo)).toList(),
    );
  }

}
