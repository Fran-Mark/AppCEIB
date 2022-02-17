import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OtherUsersInfo with ChangeNotifier {
  final _usersInfo = FirebaseFirestore.instance.collection('users');

  Future<String?> getUserImageURL(String uid) async {
    final _doc = await _usersInfo.doc(uid).get();
    final _url = _doc.data()?['imgURL'] as String?;
    return _url;
  }

  Future<String> getUserDisplayName(String uid) async {
    final _doc = await _usersInfo.doc(uid).get();
    final _url = _doc.data()?['displayName'] as String;
    return _url;
  }

  Future<Map<String, String?>> getUserInfo(String uid) async {
    final _url = await getUserImageURL(uid);
    final _displayName = await getUserDisplayName(uid);
    final _map = {"displayName": _displayName, "imgURL": _url};
    return _map;
  }
}
