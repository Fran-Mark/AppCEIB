import 'package:ceib/widgets/event_screen_builder.dart';
import 'package:flutter/material.dart';

class NewEvent extends StatelessWidget {
  const NewEvent({Key? key}) : super(key: key);
  static const routeName = '/new-event';

  @override
  Widget build(BuildContext context) {
    return EventBuilder();
  }
}
