import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './event.dart';

class Events with ChangeNotifier {
  final _eventsCollection = FirebaseFirestore.instance.collection('events');
  final _editorsCollection = FirebaseFirestore.instance.collection('editors');

  Future<bool> isEditor(String email) async {
    final _query = await _editorsCollection.doc(email).get();

    if (_query.exists)
      return true;
    else
      return false;
  }

  Future<String> updateEvent(
      User user, Event newEvent, DocumentSnapshot originalEvent) async {
    try {
      final _isEditor = await isEditor(user.email!);
      if (_isEditor) {
        await originalEvent.reference.update({
          'title': newEvent.title,
          'description': newEvent.description,
          'date': newEvent.date.toString(),
          'isUrgent': newEvent.isUrgent,
        });
        return "Editado!";
      } else
        return "No tenés permisos";
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<String> deleteEvent(Event event, User user) async {
    try {
      final _isEditor = await isEditor(user.email!);
      if (_isEditor) {
        await _eventsCollection.doc('${event.id}').delete();
        return "Borrado exitosamente";
      } else
        return "No tenés permisos para borrar";
    } catch (e) {
      return "Algo salió mal";
    }
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
