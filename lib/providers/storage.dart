import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Storage with ChangeNotifier {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File img, String path) async {
    try {
      final _task = _storage.ref(path).putFile(img);
      await _task.whenComplete(() {});

      notifyListeners();
      return "Foto subida";
    } on Exception {
      return "Algo salió mal";
    }
  }

  Future<String?> getUserImageURL(String email) async {
    try {
      final _url =
          await _storage.ref('/profile-pictures/$email').getDownloadURL();
      return _url;
    } on Exception {
      return null;
    }
  }

  Future<String> deleteProfilePicture(String email) async {
    try {
      await _storage.ref('/profile-pictures/$email').delete();
      notifyListeners();
      return "Foto borrada";
    } on Exception {
      return "Algo salió mal";
    }
  }
}
