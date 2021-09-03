import 'package:flutter/material.dart';
import '../extensions/datetime_extension.dart';

class EventItem extends StatelessWidget {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final bool isUrgent;

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isUrgent,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              title,
            ),
          ),
          Container(
            height: 10,
          ),
          Row(children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Text(
                      description,
                    ))),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(date.formatDate()),
            )
          ])
        ],
      ),
    );
  }
}
