import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:crypto_app/core/core.dart';
import 'package:crypto_app/data_source/data_source.dart';
import 'package:crypto_app/widgets/coin_list_tile.widget.dart';
import 'package:crypto_app/widgets/loading.widget.dart';
import 'package:crypto_app/widgets/error.widget.dart';

import './selectors.dart';

class MarketsPage extends StatelessWidget {
  final Store<AppState> store;

  MarketsPage({this.store}) {
    final model = MarketsSelectors.create(this.store);
    model.onRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.0, -0.6),
              radius: 0.7,
              colors: [
                const Color.fromRGBO(56, 64, 104, 1),
                const Color.fromRGBO(42, 49, 81, 1),
              ],
              stops: [0.4, 1.0],
            ),
          ),
        ),
        Scaffold(
            backgroundColor: Colors.black,
            body: _VolumeListWidget(),
            bottomNavigationBar: BottomAppBar(
              elevation: 0.0,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                  _CurrencyDropDownWidget(),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                ],
              ),
            ))
      ],
    );
  }
}

class _VolumeListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MarketsSelectors>(
      converter: (Store<AppState> store) => MarketsSelectors.create(store),
      builder: (BuildContext context, MarketsSelectors model) {
        final data = model.data();
        return model.dataState() == ServiceDataState.Loading
            ? Loading()
            : model.dataState() == ServiceDataState.Error
                ? ErrorMessageWidget(message: 'Yüklenirken bir hata oluştu.')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 0.0),
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      final item = data[i];
                      return CoinListTile(
                          imageUrl: item.imageUrl,
                          name: item.name,
                          fullName: item.fullName,
                          formattedPrice: item.price,
                          formattedPriceChange: item.priceChangeDisplay,
                          priceChange: item.priceChange,
                          onSelect: (SelectedCoinTile data) {
                            model.onNavigateToDetails(CoinInformation(
                              priceChange: data.priceChange,
                              fullName: data.fullName,
                              imageUrl: data.imageUrl,
                              name: data.name,
                              formattedPriceChange: data.formattedPriceChange,
                              formattedPrice: data.formattedPrice,
                            ));
                          });
                    },
                  );
      },
    );
  }
}

class _CurrencyDropDownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MarketsSelectors>(
        converter: (Store<AppState> store) => MarketsSelectors.create(store),
        builder: (BuildContext context, MarketsSelectors model) {
          return DropdownButton(
            value: model.activeCurrency(),
            items: model.availableCurrencies().map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String currency) {
              model.onChangeCurrency(currency);
            },
          );
        });
  }
}
