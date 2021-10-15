import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension UserExtension on User {
  Future<bool> isEditor() async {
    final _editorsCollection = FirebaseFirestore.instance.collection('editors');
    final _query = await _editorsCollection.doc(email).get();

    if (_query.exists)
      return true;
    else
      return false;
  }
}
