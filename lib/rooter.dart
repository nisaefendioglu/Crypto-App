import 'package:crypto_app/models/users.dart';
import 'package:crypto_app/pages/homePage.dart';
import 'package:crypto_app/pages/login.dart';
import 'package:crypto_app/services/authorization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Rooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authorizationService =
        Provider.of<AuthorizationService>(context, listen: false);
    return StreamBuilder(
        stream: _authorizationService.statusTracker,
        //bağlantı kurulana dek yükleniyor ifadesi gösterilmesi için;
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          //data kontrolü
          if (snapshot.hasData) {
            Users activeUser = snapshot.data;
            _authorizationService.activeUserId = activeUser.id;
            return HomePage();
          } else {
            return Login();
          }
        });
  }
}
