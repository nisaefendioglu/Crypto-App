import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Users {
  final String id;
  final String userName;
  final String photoUrl;
  final String mail;
  final String about;

  Users(
      {@required this.id, this.userName, this.photoUrl, this.mail, this.about});

//kullanıcı işlemleri
  factory Users.firebasedenUret(User user) {
    return Users(
      id: user.uid,
      userName: user.displayName,
      photoUrl: user.photoURL,
      mail: user.email,
    );
  }

  factory Users.dokumandanUret(DocumentSnapshot doc) {
    var docData = doc.data();
    return Users(
      id: doc.id,
      userName: docData['userName'],
      mail: docData['email'],
      photoUrl: docData['fotoUrl'],
      about: docData['hakkinda'],
    );
  }
}
