import 'package:crypto_app/services/authorization_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[_profileInfo()],
      ),
    );
  }

  Widget _profileInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 50.0,
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Kullanıcı Adı",
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text("Hakkında"),
          SizedBox(
            height: 10.0,
          ),
          _profileEditButton(),
          SizedBox(
            height: 10.0,
          ),
          _logoutButton(),
        ],
      ),
    );
  }

  Widget _profileEditButton() {
    return Container(
      width: double.infinity,
      child: OutlineButton(
        onPressed: () {},
        child: Text("Profili Düzenle"),
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      width: double.infinity,
      child: OutlineButton(
        borderSide: BorderSide(color: Colors.red, width: 1),
        onPressed: () {
          _logout();
        },
        child: Text("Çıkış Yap"),
      ),
    );
  }

  void _logout() {
    Provider.of<AuthorizationService>(context, listen: false).logOut();
  }
}
