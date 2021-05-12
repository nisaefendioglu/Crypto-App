import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSeriesChartWidget extends StatefulWidget {
  final List<ChartDataModel> data;

  TimeSeriesChartWidget({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimeSeriesChartStateWidget(
      data: data,
    );
  }
}

class _TimeSeriesChartStateWidget extends State<TimeSeriesChartWidget> {
  final GlobalKey<_ChartSliderInformationStateWidget> _key = GlobalKey();
  List<ChartDataModel> data = [];
  ChartDataModel _selectionValue = ChartDataModel(
    value: -1,
    time: null,
  );

  _TimeSeriesChartStateWidget({
    this.data,
  });

  @override
  void initState() {
    super.initState();
    if (data.length > 0) {
      final index = (data.length / 2).floor();
      _selectionValue = ChartDataModel(
        value: data[index].value,
        time: data[index].time,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
          child: Column(
            children: <Widget>[
              _buildChart(),
            ],
          ),
        ),
        Positioned(
          child: _ChartSliderInformationWidget(
            model: _selectionValue,
            key: _key,
          ),
          right: 10.0,
          top: 10.0,
        ),
      ],
    );
  }

  Widget _buildChart() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        child: Container(
          padding: const EdgeInsets.all(0.0),
          alignment: Alignment.center,
          child: data.length == 0
              ? Icon(Icons.error)
              : _TimeChartWidget(
            data: data,
            onChange: (model) {
              _key.currentState.update(model);
            }
          ),
        ),
      ),
    );
  }

}

class ChartDataModel {
  final DateTime time;
  final num value;

  ChartDataModel({this.time, this.value});
}

class _TimeChartWidget extends StatelessWidget {

  final List<ChartDataModel> data;
  ChartDataModel _model;
  final Function(ChartDataModel) onChange;

  _TimeChartWidget({
    Key key,
    this.data,
    this.onChange
  }) : super(key: key) {
    if (data.length > 0) {
      final index = (data.length / 2).floor();
      _model = ChartDataModel(
        value: data[index].value,
        time: data[index].time,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _createHistData(data),
      animate: false,
      defaultInteractions: false,
      domainAxis: charts.DateTimeAxisSpec(
        showAxisLine: true,
        renderSpec: charts.SmallTickRendererSpec(
          minimumPaddingBetweenLabelsPx: 0,
          labelStyle: charts.TextStyleSpec(
            color: charts.Color.fromHex(code: '#848eaf'),
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.Color.fromHex(code: '#343c5c'),
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
          charts.BasicNumericTickProviderSpec(zeroBound: false),
          showAxisLine: true,
          renderSpec: charts.GridlineRendererSpec(
            tickLengthPx: 2,
            labelStyle: charts.TextStyleSpec(
              color: charts.Color.fromHex(code: '#848eaf'),
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.Color.fromHex(code: '#343c5c'),
            ),
          )),
      behaviors: [
        charts.Slider(
          initialDomainValue: _model.time,
          onChangeCallback: _onSliderChange,
          style: charts.SliderStyle(
              fillColor: charts.Color(a: 50, r: 122, g: 132, b: 166),
              handleSize: Rectangle(0, 0, 50, 100),
              strokeWidthPx: 1.0,
              strokeColor: charts.Color.fromHex(code: '#848eaf')
          ),
          snapToDatum: true,
        )
      ],
    );
  }

  static List<charts.Series<ChartDataModel, DateTime>> _createHistData(
      List<ChartDataModel> model) {
    return [
      charts.Series<ChartDataModel, DateTime>(
        id: 'TimeSeries',
        colorFn: (_, __) => charts.Color.fromHex(code: '#b15ace'),
        fillColorFn: (_, __) => charts.Color.fromHex(code: '#b15ace'),
        strokeWidthPxFn: (_, __) => 3,
        domainFn: (ChartDataModel f, _) => f.time,
        measureFn: (ChartDataModel f, _) => f.value,
        data: model,
      )
    ];
  }

  _onSliderChange(
      point, dynamic domain, roleId, charts.SliderListenerDragState dragState) {
    void rebuild(_) {
      if (dragState == charts.SliderListenerDragState.end) {
        final model = data.where((d) => d.time.isAtSameMomentAs(domain)).single;
        if (model != null) {
          this.onChange(ChartDataModel(
            time: domain,
            value: model.value,
          ));
        }
      }
    }

    SchedulerBinding.instance.addPostFrameCallback(rebuild);
  }
}


class _ChartSliderInformationWidget extends StatefulWidget {
  final ChartDataModel model;

  _ChartSliderInformationWidget({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChartSliderInformationStateWidget(
      model: model,
    );
  }
}

class _ChartSliderInformationStateWidget extends State<_ChartSliderInformationWidget> {
  ChartDataModel model;

  _ChartSliderInformationStateWidget({
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildInformation(
          children: [
            Text(model.time == null ? '' : '${DateFormat('yyyy.MM.dd').format(model.time)}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
            ),
            Text(model.time == null ? '' : '  ${DateFormat('HH:mm:ss').format(model.time)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        _buildInformation(
          children: [
            Text(
              model.value == -1 ? '' : '${model.value}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ]
        ),
      ],
    );
  }

  Widget _buildInformation({List<Widget> children}) {
    return Container(
      child: Row(
        children: children,
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(70, 82, 130, 0.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
      padding: EdgeInsets.all(10.0),
    );
  }

  update(ChartDataModel m) {
    setState(() {
      model = m;
    });
  }
}