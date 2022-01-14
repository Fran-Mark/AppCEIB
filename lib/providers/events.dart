import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../extensions/user_extension.dart';
import '../models/event.dart';

class Events with ChangeNotifier {
  final _eventsCollection = FirebaseFirestore.instance.collection('events');

  Future<String> updateEvent(
      User user, Event newEvent, DocumentSnapshot originalEvent) async {
    try {
      final _isEditor = await user.isEventsEditor();
      if (_isEditor) {
        await originalEvent.reference.update({
          'title': newEvent.title,
          'description': newEvent.description,
          'date': newEvent.date.toString(),
          'place': newEvent.place,
          'link': newEvent.link,
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
      final _isEditor = await user.isEventsEditor();
      if (_isEditor) {
        await _eventsCollection.doc(event.id).delete();
        return "Borrado exitosamente";
      } else
        return "No tenés permisos para borrar";
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<String> addEvent(Event event, User user) async {
    try {
      final _isEditor = await user.isEventsEditor();

      if (_isEditor) {
        await _eventsCollection.add({
          'title': event.title,
          'description': event.description,
          'date': event.date.toString(),
          'place': event.place,
          'link': event.link,
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
