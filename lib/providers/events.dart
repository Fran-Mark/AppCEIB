import 'dart:async';

import 'package:ceib/extensions/user_extension.dart';
import 'package:ceib/models/event.dart';
import 'package:ceib/screens/initial_tabs/main_screen.dart';
import 'package:ceib/services/notifications/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Events with ChangeNotifier {
  final _eventsCollection = FirebaseFirestore.instance.collection('events');
  final _eventsStream = FirebaseFirestore.instance
      .collection('events')
      .orderBy('timestamp', descending: true)
      .snapshots();

  late StreamSubscription _subs;
  late DateTime _lastTimestamp;

  @override
  void dispose() {
    _subs.cancel();
    super.dispose();
  }

  DateTime _computeLastTimestamp(QuerySnapshot<Map<String, dynamic>> event) {
    if (event.docs.isNotEmpty) {
      return DateTime.parse(event.docs[0].data()['timestamp'] as String);
    }
    return DateTime(2019);
  }

  void init() async {
    final _lastEvent = await _eventsCollection
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    _lastTimestamp = _computeLastTimestamp(_lastEvent);

    _subs = _eventsStream.listen((snapshot) {
      final _newTimestamp = _computeLastTimestamp(snapshot);
      if (_newTimestamp.isAfter(_lastTimestamp)) {
        _lastTimestamp = _newTimestamp;
        LocalNotificationService.displayLocalNotification(
            "Anuncio nuevo!", "Se publicó un nuevo anuncio, entrá para leerlo",
            payload: MainScreen.routeName);
        notifyListeners();
      }
    });
  }

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
          'timestamp': DateTime.now().toString(),
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

  Stream<QuerySnapshot> get eventsStream {
    return _eventsStream;
  }
}
