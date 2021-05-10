import 'dart:io';

import 'package:crypto_app/models/users.dart';
import 'package:crypto_app/services/authorization_service.dart';
import 'package:crypto_app/services/firestoreservice.dart';
import 'package:crypto_app/services/storageservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  final Users profile;

  const ProfileEdit({Key key, this.profile}) : super(key: key);
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  var _formKey = GlobalKey<FormState>();
  String _userName;
  File _valuePhoto;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          "Profili Düzenle",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context)),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
              onPressed: () => _save()),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _loading
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          _profilePhoto(),
          _userInfo(),
        ],
      ),
    );
  }

  Future _save() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      _formKey.currentState.save();

      String profilePhotoUrl;
      if (_valuePhoto == null) {
        profilePhotoUrl = widget.profile.photoUrl;
      } else {
        profilePhotoUrl = await StorageService().profilePhotoAdd(_valuePhoto);
      }

      String activeUserId =
          Provider.of<AuthorizationService>(context, listen: false)
              .activeUserId;
      //veritabanına güncel verileri eklemek için.
      FireStoreService().userUpdate(
          userId: activeUserId, userName: _userName, photoUrl: profilePhotoUrl);

      setState(() {
        _loading = false;
      });

      Navigator.pop(context);
    }
  }

  _profilePhoto() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
      child: Center(
        child: InkWell(
          onTap: _galleryChoose,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: _valuePhoto == null
                ? NetworkImage(widget.profile.photoUrl)
                : FileImage(_valuePhoto), //galeriden fotoğraf ekleme.
            radius: 55.0,
          ),
        ),
      ),
    );
  }

  _galleryChoose() async {
    var image = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80);

    setState(() {
      _valuePhoto = File(image.path);
    });
  }

  _userInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 120.0,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              //varsayılan kullanıcı adı düzenleme ekranında da gözükmesi için initialvalue çalışıyor.
              initialValue: widget.profile.userName,
              decoration: InputDecoration(labelText: "Kullanıcı Adı"),
              validator: (inputValue) {
                return inputValue.trim().length <= 3
                    ? "Kullanıcı Adı en az 4 karakter olmalı."
                    : null;
              },
              onSaved: (inputValue) {
                _userName = inputValue;
              },
            ),
          ],
        ),
      ),
    );
  }
}
