import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './event.dart';

class Events with ChangeNotifier {
  final _eventsCollection = FirebaseFirestore.instance.collection('events');
  final _editorsCollection = FirebaseFirestore.instance.collection('editors');

  List<Event> _items = [
    Event(
        id: "1",
        title: 'Test Event',
        description: "This is a test eent",
        date: DateTime.now())
  ];

  List<Event> get items {
    return [..._items];
  }

  Future<bool> isEditor(String email) async {
    final _query = await _editorsCollection.doc(email).get();

    if (_query.exists)
      return true;
    else
      return false;
  }

  Future<String> addEvent(Event event, User user) async {
    try {
      final _isEditor = await isEditor(user.email!);

      if (_isEditor) {
        await _eventsCollection.add({
          'title': event.title,
          'description': event.description,
          'date': event.date.toString(),
          'isUrgent': event.isUrgent,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'uid': user.uid,
          'username': user.displayName
        });
        return "Evento agregado!";
      } else {
        return "No tenés permisos!";
      }
    } catch (e) {
      return "Algo salió mal";
    }
  }
}
