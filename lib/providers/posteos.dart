import 'package:ceib/widgets/posteo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Posteos with ChangeNotifier {
  final _posteos = FirebaseFirestore.instance.collection("posteos");

  Future<List<Posteo>> getPosteos(int amount, String uid) async {
    final _query = await _posteos.orderBy('date').limit(amount).get();
    final docs = _query.docs;
    final List<Posteo> _list = [];
    for (final element in docs) {
      final _docData = element.data();
      final _likeList = _docData['likedBy'] as List<String>;
      final _isLiked = _likeList.contains(uid);
      final _posteo = Posteo(
        postID: element.id,
        data: _docData['data'] as String?,
        date: DateTime.tryParse(_docData['date'] as String),
        likeCount: _docData['likesCount'] as int?,
        uid: _docData["uid"] as String,
        isLiked: _isLiked,
      );
      _list.add(_posteo);
    }
    return _list;
  }

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
    return _posteos.orderBy('date', descending: true).snapshots();
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
}
