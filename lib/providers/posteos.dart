import 'package:ceib/widgets/posteo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Posteos with ChangeNotifier {
  final _posteos = FirebaseFirestore.instance.collection("posteos");
  final _userCollection = FirebaseFirestore.instance.collection('users');
  Map<String, Map<String, String?>>? _cachedValues;
  final _numberOfLoadedPosts = 200;

  Future<String> uploadPost(Posteo posteo) async {
    try {
      await _posteos.add({
        'data': posteo.data,
        'date': posteo.date.toString(),
        'uid': posteo.uid,
        'likesCount': posteo.likeCount,
      });
      return "Subido!";
    } on Exception {
      return "Algo salió mal";
    }
  }

  Future<String> deletePost(String postID) async {
    try {
      await _posteos.doc(postID).delete();
      return "Borrado!";
    } on Exception {
      return "Algo salió mal";
    }
  }

  Future<bool> isLiked(String postID, String uid) async {
    final _doc = await _posteos.doc(postID).get();
    final _list = _doc.data()!['likedBy'] as List<String>?;
    if (_list == null) return false;
    final _result = _list.contains(uid);
    return _result;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> posteos() {
    return _posteos
        .orderBy('date', descending: true)
        .limit(_numberOfLoadedPosts)
        .snapshots();
  }

  Map<String, Map<String, String?>>? get cachedPosts {
    return _cachedValues;
  }

  Future<void> updateCachedData() async {
    final _snapshot = await posteos().first;
    Map<String, Map<String, String?>>? _initialMap;
    // ignore: avoid_function_literals_in_foreach_calls
    _snapshot.docs.forEach((element) async {
      final _postID = element.id;
      final _data = element.data();
      final _uid = _data['uid'] as String?;
      if (_uid == null) return;
      final _userDoc = await _userCollection.doc(_uid).get();
      final _userData = _userDoc.data();
      if (_userData == null) return;
      final _displayName = _userData['displayName'] as String;
      final _imgURL = _userData['imgURL'] as String?;
      final _map = {
        //"postID": _postID,
        "displayName": _displayName,
        "imgURL": _imgURL
      };
      _initialMap ??= {};
      _initialMap!.putIfAbsent(_postID, () => _map);
      if (_initialMap!.length == _snapshot.docs.length) {
        _cachedValues = _initialMap;
        notifyListeners();
      }
    });
  }

  Future<void> addLike(String postID, String uid) async {
    await _posteos.doc(postID).update({
      'likesCount': FieldValue.increment(1),
      'likedBy': FieldValue.arrayUnion([uid])
    });
  }

  Future<void> removeLike(String postID, String uid) async {
    await _posteos.doc(postID).update({
      'likesCount': FieldValue.increment(-1),
      'likedBy': FieldValue.arrayRemove([uid])
    });
  }

  Future<List<Map<String, String?>>> getComments(String postID) async {
    final _allComentsSnapshot =
        await _posteos.doc(postID).collection("comments").get();
    final _comments = _allComentsSnapshot.docs.map((e) {
      final _data = e.data();
      final Map<String, String?> _comment = {
        "data": _data["data"] as String?,
        "uid": _data["uid"] as String
      };
      return _comment;
    }).toList();
    return _comments;
  }
}
