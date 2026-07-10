// Wrapper around Firebase Storage for uploading/retrieving files (e.g. profile images).
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadFile({required String path, required File file}) async {
    final ref = _storage.ref(path);
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<void> deleteFile(String path) {
    return _storage.ref(path).delete();
  }
}
