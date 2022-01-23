import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Storage with ChangeNotifier {
  final _storage = FirebaseStorage.instance;
  // UploadTask? _workingTask;

  // Stream? get currentTask {
  //   if (currentTask != null) {
  //     return _workingTask!.snapshotEvents;
  //   } else
  //     return null;
  // }

  Future<String> uploadImage(File image, String path) async {
    try {
      final _task = _storage.ref(path).putFile(image);
      // _workingTask = _task;
      await _task.whenComplete(() {});
      notifyListeners();
      return "Salió bien";
    } on Exception {
      return "Maaal";
    }
  }

  Future<String?> getUserImageURL(String email) async {
    try {
      final _ref = _storage.ref('/profile-pictures/$email');
      final _url = await _ref.getDownloadURL();
      return _url;
    } on Exception {
      return null;
    }
  }
}
