import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/widgets/event_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../extensions/user_extension.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _isEditor = _user?.isEventsEditor();

    return FutureBuilder(
        future: _isEditor,
        builder: (context, isEditor) {
          var _isEditorSnapshot = isEditor.data as bool?;
          _isEditorSnapshot ??= false;
          return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('events').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  if (snapshot.data == null)
                    return const Center(
                        child: CircularProgressIndicator.adaptive());

                  final _events = snapshot.data!.docs;
                  final _lenght = _events.length;
                  if (_lenght == 0) {
                    return Center(
                      child: Text(
                        "Nada por aquí",
                        style: GoogleFonts.hindMadurai(fontSize: 30),
                      ),
                    );
                  }

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    children: _events.map((e) {
                      return EventItem(
                        eventReference: e,
                        isEditor: _isEditorSnapshot!,
                      );
                    }).toList(),
                  );
                }),
            if (_isEditorSnapshot == true)
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
        });
  }
}
