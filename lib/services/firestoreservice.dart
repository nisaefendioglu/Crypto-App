import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/models/users.dart';

class FireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime time = DateTime.now();

  Future<void> createUser({id, mail, userName, photoUrl = ""}) async {
    await _firestore.collection("users").doc(id).set({
      "userName": userName,
      "mail": mail,
      "photoUrl": photoUrl,
      "about": "",
      "createTime": time
    });
  }

  Future<Users> bringUser(id) async {
    DocumentSnapshot doc =
        await _firestore.collection("kullanicilar").doc(id).get();
    if (doc.exists) {
      Users users = Users.dokumandanUret(doc);
      return users;
    }
    return null;
  }
}
