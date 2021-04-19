import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  Reference _storage = FirebaseStorage.instance.ref();
  String photoId;

  Future<String> profilePhotoAdd(File photoFile) async {
    photoId = Uuid().v4();
    UploadTask uploadManager = _storage
        .child("images/profile/profile_$photoId.jpg")
        .putFile(photoFile);

    TaskSnapshot snapshot = await uploadManager;
    String uploadPhotoUrl = await snapshot.ref.getDownloadURL();
    return uploadPhotoUrl;
  }
}
