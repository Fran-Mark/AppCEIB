import 'package:flutter/foundation.dart';

class Event with ChangeNotifier {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  bool isUrgent;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isUrgent = false,
  });

  // void _setUrgency(bool value) {
  //   isUrgent = value;
  //   notifyListeners();
  // }
}
