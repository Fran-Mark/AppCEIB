import 'package:ceib/widgets/event_screen_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditEvent extends StatelessWidget {
  const EditEvent({Key? key}) : super(key: key);
  static const routeName = '/edit-event';
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as DocumentSnapshot?;
    if (routeArgs != null) {
      final event = routeArgs;

      return EventBuilder(
        event: event,
      );
    }

    return const EventBuilder();
  }
}
