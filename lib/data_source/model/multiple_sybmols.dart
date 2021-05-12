import 'package:flutter/foundation.dart';

class MultipleSymbols {

  final Map<dynamic, dynamic> raw;
  final Map<dynamic, dynamic> display;

  MultipleSymbols({
    @required this.raw,
    @required this.display,
  });

  factory MultipleSymbols.fromJson(dynamic json) {

    final raw = Map.of(json['RAW']);
    final display = Map.of(json['DISPLAY']);

    return MultipleSymbols(
      display: display,
      raw: raw,
    );
  }
}