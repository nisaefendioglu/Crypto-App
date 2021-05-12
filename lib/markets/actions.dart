import 'package:flutter/foundation.dart';

class MarketsRequestDataAction {}


class MarketsChangePageAction {
  final int page;
  MarketsChangePageAction({
    @required this.page
  }): assert(page != null);
}

class MarketsRefresh {}