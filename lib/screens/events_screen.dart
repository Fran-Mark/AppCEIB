import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/event.dart';
import 'package:ceib/providers/events.dart';
import 'package:ceib/screens/edit_event_screen.dart';
import 'package:ceib/widgets/my_alert_dialog.dart';
import 'package:ceib/widgets/event_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/events.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _eventsData = Provider.of<Events>(context);
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;

    Future<void> _deleteEvent(Event event, User user) async {
      final result = await _eventsData.deleteEvent(event, user);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: result));
    }

    return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: const CircularProgressIndicator.adaptive());
            if (snapshot.data == null)
              return Center(child: const CircularProgressIndicator.adaptive());

            final _events = snapshot.data!.docs;
            final _lenght = _events.length;
            if (_lenght == 0)
              return Center(
                  child: FractionallySizedBox(
                heightFactor: .8,
                widthFactor: .6,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: Center(
                    child: Text(
                      "No hay eventos",
                      style: GoogleFonts.raleway(fontSize: 40),
                    ),
                  ),
                ),
              ));
            return ListView(
              physics: BouncingScrollPhysics(),
              children: _events.map((e) {
                final _event = Event(
                    id: e.id,
                    title: e['title'],
                    description: e['description'],
                    date: DateTime.parse(e['date']),
                    isUrgent: e['isUrgent']);
                return Slidable(
                  actionExtentRatio: 0.1,
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
                        Navigator.of(context).pushNamed(EditEvent.routeName,
                            arguments: passArgumentsToEdit(
                                _event.id,
                                _event.title,
                                _event.description,
                                _event.date,
                                _event.isUrgent));
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
                  actionPane: SlidableDrawerActionPane(),
                  child: EventItem(event: _event),
                );
              }).toList(),
            );
          }),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/new-event');
          },
          child: Icon(Icons.add),
        ),
      )
    ]);
  }
}
