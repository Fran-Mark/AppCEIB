import 'package:ceib/providers/user_data.dart';
import 'package:ceib/widgets/event_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isEventsEditor = Provider.of<UserData>(context).isEventsEditor;

    return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator.adaptive());
            if (snapshot.data == null)
              return const Center(child: CircularProgressIndicator.adaptive());

            final _events = snapshot.data!.docs;
            final _length = _events.length;
            if (_length == 0) {
              return Center(
                child: Text(
                  "Nada por aquí",
                  style: GoogleFonts.hindMadurai(fontSize: 30),
                ),
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              itemCount: _length,
              itemBuilder: (context, index) {
                final _eventReference = _events[index];
                return EventItem(
                  eventReference: _eventReference,
                  isEditor: _isEventsEditor,
                );
              },
            );
          }),
      if (_isEventsEditor == true)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/new-event');
            },
            child: const Icon(Icons.add),
          ),
        )
    ]);
  }
}
