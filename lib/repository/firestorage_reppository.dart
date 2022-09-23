import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirestorageRepository {
  UploadTask uploadImageFile(String? uid, String? filename, File? file) {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('user/$uid')
        .child('/$filename.jpg');

    return ref.putFile(file!);
  }
}
