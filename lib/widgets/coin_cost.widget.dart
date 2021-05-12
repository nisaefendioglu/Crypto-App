import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/data_source/data_source.dart';
import './time_series_chart.widget.dart';

class CoinCostWidget extends StatefulWidget {

  final List<HistogramDataModel> histData;

  CoinCostWidget({Key key, this.histData,}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CoinCostState(
      histData: histData,
    );
  }

}

class CoinCostState extends State<CoinCostWidget> {

  List<HistogramDataModel> histData = [];

  CoinCostState({this.histData,});

  @override
  Widget build(BuildContext context) {
    return TimeSeriesChartWidget(
      data: histData.map((d) => ChartDataModel(time: d.time, value: d.close)).toList(),
    );
  }
}