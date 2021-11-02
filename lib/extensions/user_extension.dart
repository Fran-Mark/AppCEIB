import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension UserExtension on User {
  Future<bool> isEventsEditor() async {
    final _permissionsCollection =
        FirebaseFirestore.instance.collection('permissions');
    final _query = await _permissionsCollection.doc('events').get();
    final _names = _query.data()!;
    if (_names[email] == true) return true;
    return false;
  }

  Future<bool> isSportsEditor() async {
    final _permissionsCollection =
        FirebaseFirestore.instance.collection('permissions');
    final _query = await _permissionsCollection.doc('sports').get();
    final _names = _query.data()! as Map<String, bool>;
    if (_names[email] == true) return true;
    return false;
  }
}
