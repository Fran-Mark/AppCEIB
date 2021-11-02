import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/models/event.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/events.dart';
import 'package:ceib/screens/edit_event_screen.dart';
import 'package:ceib/widgets/event_item.dart';
import 'package:ceib/widgets/my_alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../extensions/user_extension.dart';

import '../../providers/events.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _eventsData = Provider.of<Events>(context);

    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;

    Future<void> _deleteEvent(Event event, User user) async {
      Navigator.of(context).pop();
      final result = await _eventsData.deleteEvent(event, user);
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: result));
    }

    return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator.adaptive());
            if (snapshot.data == null)
              return const Center(child: CircularProgressIndicator.adaptive());

            final _events = snapshot.data!.docs;
            final _lenght = _events.length;
            if (_lenght == 0)
              return Center(
                  child: FractionallySizedBox(
                heightFactor: .8,
                widthFactor: .6,
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: Center(
                    child: Text(
                      "No hay eventos",
                      style: GoogleFonts.raleway(fontSize: 40),
                    ),
                  ),
                ),
              ));
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: _events.map((e) {
                final _event = Event(
                    id: e.id,
                    title: e['title'] as String,
                    description: e['description'] as String,
                    date: DateTime.parse(e['date'] as String),
                    isUrgent: e['isUrgent'] as bool);

                return Slidable(
                  actionExtentRatio: .2,
                  secondaryActions: [
                    IconSlideAction(
                      caption: 'Cerrar',
                      color: Colors.black,
                      icon: Icons.close,
                      onTap: () {},
                    ),
                    IconSlideAction(
                      caption: 'Editar',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(EditEvent.routeName, arguments: e);
                      },
                    ),
                    IconSlideAction(
                      caption: 'Eliminar',
                      color: Colors.red,
                      icon: Icons.remove,
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return MyAlertDialog(
                              title: "Seguro que querés eliminarlo?",
                              content: "surestuart",
                              handler: () => _deleteEvent(_event, _user!),
                            );
                          }),
                    )
                  ],
                  actionPane: const SlidableDrawerActionPane(),
                  child: EventItem(event: _event),
                );
              }).toList(),
            );
          }),
      FutureBuilder(
          future: _user?.isEventsEditor(),
          builder: (context, isEditor) {
            final _isEditor = isEditor.data as bool?;
            if (_isEditor == true) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/new-event');
                  },
                  child: const Icon(Icons.add),
                ),
              );
            } else {
              return Container();
            }
          })
    ]);
  }
}
