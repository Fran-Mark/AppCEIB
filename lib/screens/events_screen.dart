import 'package:ceib/providers/events.dart';
import 'package:ceib/widgets/event_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventsData = Provider.of<Events>(context);
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      // RefreshIndicator(
      //   onRefresh: () => _refreshEvents(context),
      //   child: ListView.builder(
      //       itemCount: eventsData.items.length,
      //       itemBuilder: (_, index) => Column(
      //             children: [
      //               EventItem(
      //                 id: eventsData.items[index].id,
      //                 title: eventsData.items[index].title,
      //                 description: eventsData.items[index].description,
      //                 date: eventsData.items[index].date,
      //                 isUrgent: eventsData.items[index].isUrgent,
      //               ),
      //               Divider()
      //             ],
      //           )),
      // ),
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            if (snapshot.data == null) return Text("No hay docs");

            return ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((e) {
                return Slidable(
                  actionExtentRatio: 0.2,
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
                      onTap: () {},
                    ),
                    IconSlideAction(
                      caption: 'Eliminar',
                      color: Colors.red,
                      icon: Icons.remove,
                      onTap: () {},
                    )
                  ],
                  actionPane: SlidableDrawerActionPane(),
                  child: EventItem(
                      id: e.id,
                      title: e['title'],
                      description: e['description'],
                      date: DateTime.parse(e['date']),
                      isUrgent: e['isUrgent']),
                );
              }).toList(),
            );
          }),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/new-event');
            print(eventsData.items.length);
          },
          child: Icon(Icons.add),
        ),
      )
    ]);
  }
}
