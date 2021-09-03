import 'dart:async';

import 'package:ceib/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './event.dart';

class Events with ChangeNotifier {
  final _eventsCollection = FirebaseFirestore.instance.collection('events');

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

  // Future<void> fetchEvents() async {
  //   final url =
  //       Uri.https('appceib-default-rtdb.firebaseio.com', '/events.json');

  //   try {
  //     final response = await http.get(url);
  //     final responseBody = json.decode(response.body) as Map<String, dynamic>;
  //     final List<Event> _loadedEvents = [];
  //     responseBody.forEach((eventId, eventData) {
  //       if (DateTime.parse(eventData['date']).isAfter(DateTime.now())) {
  //         _loadedEvents.add(Event(
  //             id: eventId,
  //             title: eventData['title'],
  //             description: eventData['description'],
  //             date: DateTime.parse(eventData['date']),
  //             isUrgent: eventData['isUrgent']));
  //       }
  //     });
  //     _items = _loadedEvents;
  //     notifyListeners();
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  // Future<void> addEvent(Event event) async {
  //   final url =
  //       Uri.https('appceib-default-rtdb.firebaseio.com', '/events.json');
  //   final response = await http.post(url,
  //       body: json.encode({
  //         'title': event.title,
  //         'description': event.description,
  //         'date': event.date.toString(),
  //         'isUrgent': event.isUrgent
  //       }));
  //   final responseBody = json.decode(response.body) as Map<String, dynamic>;
  //   final newEvent = Event(
  //       id: responseBody['name'],
  //       title: event.title,
  //       description: event.description,
  //       date: event.date);
  //   _items.add(newEvent);
  //   notifyListeners();
  // }

  StreamSubscription<QuerySnapshot>? _eventsSubscription;

  Future<void> fetchEvents() async {
    _eventsSubscription = _eventsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((data) {
      _items = [];
      data.docs.forEach((element) {
        final newEvent = Event(
            id: element.id,
            title: element.data()['title'],
            description: element.data()['description'],
            date: DateTime.parse(element.data()['date']));
        _items.add(newEvent);
      });
    });

    notifyListeners();
  }

  Future<DocumentReference> addEvent(Event event, User user) async {
    final _isEditor = await isEditor(user);
    if (_isEditor) {
      throw Exception("No tenés permisos de escritura");
    }
    try {
      final response = await _eventsCollection.add(<String, dynamic>{
        'title': event.title,
        'description': event.description,
        'date': event.date,
        'urgency': event.isUrgent,
        'timestamp': DateTime.now().microsecondsSinceEpoch,
        'uid': user.uid,
        'name': user.displayName,
      });

      final newEvent = Event(
          id: response.id,
          title: event.title,
          description: event.description,
          date: event.date);
      _items.add(newEvent);
      notifyListeners();
      return response;
    } catch (e) {
      throw e;
    }
  }
}
