import 'package:ceib/widgets/posteo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Posteos with ChangeNotifier {
  final _posteos = FirebaseFirestore.instance.collection("posteos");

  Future<List<Posteo>> getPosteos(int amount) async {
    final _query = await _posteos.orderBy('date').limit(amount).get();
    final docs = _query.docs;
    final List<Posteo> _list = [];
    for (final element in docs) {
      final _docData = element.data();
      final _posteo = Posteo(
        data: _docData['data'] as String?,
        date: DateTime.tryParse(_docData['date'] as String),
        email: _docData['email'] as String?,
        likeCount: _docData['likesCount'] as int?,
      );
      _list.add(_posteo);
    }
    return _list;
  }
}
