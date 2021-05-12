import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:crypto_app/core/core.dart';

import 'package:crypto_app/markets/markets.dart';
import 'package:crypto_app/coin_details/coin_details.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: appStateMiddleware(),
    );

    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
          ),
          navigatorKey: NavigationKeys.navigationState,
          home: MarketsPage(
            store: store,
          ),
          routes: <String, WidgetBuilder>{
            '/details': (BuildContext context) => DetailsPage(
                  store: store,
                )
          },
        ));
  }
}
