import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './event.dart';

class Events with ChangeNotifier {
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

  Future<void> fetchEvents() async {
    final url =
        Uri.https('appceib-default-rtdb.firebaseio.com', '/events.json');

    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final List<Event> _loadedEvents = [];
      responseBody.forEach((eventId, eventData) {
        if (DateTime.parse(eventData['date']).isAfter(DateTime.now())) {
          _loadedEvents.add(Event(
              id: eventId,
              title: eventData['title'],
              description: eventData['description'],
              date: DateTime.parse(eventData['date']),
              isUrgent: eventData['isUrgent']));
        }
      });
      _items = _loadedEvents;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addEvent(Event event) async {
    final url =
        Uri.https('appceib-default-rtdb.firebaseio.com', '/events.json');
    final response = await http.post(url,
        body: json.encode({
          'title': event.title,
          'description': event.description,
          'date': event.date.toString(),
          'isUrgent': event.isUrgent
        }));
    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    final newEvent = Event(
        id: responseBody['name'],
        title: event.title,
        description: event.description,
        date: event.date);
    _items.add(newEvent);
    notifyListeners();
  }
}
