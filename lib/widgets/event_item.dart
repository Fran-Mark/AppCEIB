import 'package:ceib/extensions/datetime_extension.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/models/event.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/events.dart';
import 'package:ceib/screens/edit_event_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'my_alert_dialog.dart';

class EventItem extends StatelessWidget {
  const EventItem({required this.eventReference, required this.isEditor});
  final QueryDocumentSnapshot<Object?> eventReference;
  final bool isEditor;

  @override
  Widget build(BuildContext context) {
    final _eventsData = Provider.of<Events>(context);

    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _event = Event(
        id: eventReference.id,
        title: eventReference['title'] as String,
        description: eventReference['description'] as String,
        date: DateTime.parse(eventReference['date'] as String),
        isUrgent: eventReference['isUrgent'] as bool);

    Future<void> _deleteEvent(Event event, User user) async {
      Navigator.of(context).pop();
      final result = await _eventsData.deleteEvent(event, user);
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: result));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
              border: _event.isUrgent
                  ? Border.all(color: Colors.red, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (_event.isUrgent)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(color: Colors.red),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "IMPORTANTE",
                    style: GoogleFonts.secularOne(color: Colors.white),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          _event.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.alfaSlabOne(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    _event.date.formatDate(),
                    style: GoogleFonts.hindMadurai(),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 8),
                          child: Text(
                            _event.description,
                            style: GoogleFonts.hindMadurai(),
                          ))),
                ],
              ),
              if (isEditor) const Divider(),
              if (isEditor)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(EditEvent.routeName,
                              arguments: eventReference);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.redAccent,
                        )),
                    IconButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              return MyAlertDialog(
                                title: "Seguro que querés eliminarlo?",
                                content: "Surestuart",
                                handler: () => _deleteEvent(_event, _user!),
                              );
                            }),
                        icon: const Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.redAccent,
                        ))
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
