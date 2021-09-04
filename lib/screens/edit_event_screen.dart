import 'package:ceib/widgets/event_screen_builder.dart';
import 'package:flutter/material.dart';

class EditEvent extends StatelessWidget {
  const EditEvent({Key? key}) : super(key: key);
  static const routeName = '/edit-event';
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (routeArgs != null) {
      final _title = routeArgs['title'];
      final _description = routeArgs['description'];
      final _date = routeArgs['date'];
      final _isUrgent = routeArgs['isUrgent'];
      return EventBuilder(
        createNew: false,
        title: _title,
        description: _description,
        date: _date,
        isUrgent: _isUrgent,
      );
    }

    return EventBuilder(
      createNew: true,
    );
  }
}
