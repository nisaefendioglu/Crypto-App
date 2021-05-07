import 'package:crypto_app/models/users.dart';
import 'package:crypto_app/pages/profile_edit.dart';
import 'package:crypto_app/services/authorization_service.dart';
import 'package:crypto_app/services/firestoreservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String profileId;
  const Profile({Key key, this.profileId}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _activeUserId;
  Users _myprofile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Object>(
          future: FireStoreService().bringUser(widget.profileId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            _myprofile = snapshot.data;

            return ListView(
              children: <Widget>[_profileInfo(snapshot.data)],
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _activeUserId =
        Provider.of<AuthorizationService>(context, listen: false).activeUserId;
  }

  Widget _profileInfo(Users profileData) {
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
                backgroundImage: profileData?.photoUrl?.isNotEmpty ?? false
                    ? NetworkImage(profileData.photoUrl)
                    : AssetImage("images/user.png"),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            profileData.userName,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
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
      color: Colors.pink,
      width: double.infinity,
      child: OutlineButton(
        borderSide: BorderSide(color: Colors.pink, width: 0),
        onPressed: ()  {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileEdit(
                        profile: _myprofile,
                      )));
        },
        child: Text("Profili Düzenle"),
      ),
    );
  }

  Widget _logoutButton() {
    return Container(
      color: Colors.green,
      width: double.infinity,
      child: OutlineButton(
        borderSide: BorderSide(color: Colors.green, width: 0),
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
