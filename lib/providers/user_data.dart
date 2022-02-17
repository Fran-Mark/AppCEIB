import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../extensions/user_extension.dart';

class UserData with ChangeNotifier {
  UserData._internal();
  static final UserData _singleton = UserData._internal();

  static UserData getInstance() => _singleton;
  // ignore: slash_for_doc_comments
  /**
   * bool isXEditor o hasXPermission
   * imgURL
   * useremail
   * displayname
   * 
   */
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? _user;
  late bool isSportsEditor;
  late bool isEventsEditor;
  late bool canChangeUsername;
  late StreamSubscription sportsPermissions;
  late StreamSubscription eventsPermissions;
  late StreamSubscription canChangeNamePermissions;
  String? imageURL;

  @override
  void dispose() {
    sportsPermissions.cancel();
    eventsPermissions.cancel();
    canChangeNamePermissions.cancel();
    super.dispose();
  }

  bool _ckeckForPermissions(Map<String, dynamic> data) {
    final _value = data[_user?.email];
    if (_value == true) return true;
    return false;
  }

  Future<void> initSportsPermissions() async {
    isSportsEditor = await _user!.isSportsEditor();
    sportsPermissions = _firestore
        .collection('permissions')
        .doc('sports')
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        isSportsEditor = _ckeckForPermissions(event.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> initEventsPermissions() async {
    isSportsEditor = await _user!.isEventsEditor();
    eventsPermissions = _firestore
        .collection('permissions')
        .doc('events')
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        isEventsEditor = _ckeckForPermissions(event.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> initChangeUsernamePermissions() async {
    canChangeUsername = await _user!.canChangeName();
    canChangeNamePermissions = _firestore
        .collection('permissions')
        .doc('changeUsername')
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        canChangeUsername = _ckeckForPermissions(event.data()!);
        notifyListeners();
      }
    });
  }

  Future<String?> getImageURL() async {
    try {
      final _url = await _storage
          .ref('/profile-pictures/${_user!.email}')
          .getDownloadURL();
      return _url;
    } on Exception {
      return null;
    }
  }

  Future<void> refreshImageURL() async {
    imageURL = await getImageURL();
    notifyListeners();
  }

  Future<String> uploadImg(File img) async {
    try {
      final _task =
          _storage.ref('/profile-pictures/${_user!.email}').putFile(img);
      await _task.whenComplete(() {});
      final _url = await _storage
          .ref('/profile-pictures/${_user!.email}')
          .getDownloadURL();
      await _firestore
          .collection('users')
          .doc(_user?.uid)
          .update({"imgURL": _url});
      notifyListeners();
      return "Foto subida";
    } on Exception {
      return "Algo salió mal";
    }
  }

  Future<String> deleteImg() async {
    try {
      await _storage.ref('/profile-pictures/${_user?.email}').delete();
      await _firestore
          .collection('users')
          .doc(_user?.uid)
          .update({"imgURL": null});
      notifyListeners();
      return "Foto borrada";
    } on Exception {
      return "Algo salió mal";
    }
  }

  Future<void> init() async {
    _user = _auth.currentUser;
    imageURL = await getImageURL();
    await initSportsPermissions();
    await initEventsPermissions();
    await initChangeUsernamePermissions();
  }
}
