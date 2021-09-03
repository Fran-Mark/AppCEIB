import 'package:ceib/providers/events.dart';
import 'package:ceib/widgets/event_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  Future<void> _refreshEvents(BuildContext context) async {
    await Provider.of<Events>(context, listen: false).fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventsData = Provider.of<Events>(context);
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      RefreshIndicator(
        onRefresh: () => _refreshEvents(context),
        child: ListView.builder(
            itemCount: eventsData.items.length,
            itemBuilder: (_, index) => Column(
                  children: [
                    EventItem(
                      id: eventsData.items[index].id,
                      title: eventsData.items[index].title,
                      description: eventsData.items[index].description,
                      date: eventsData.items[index].date,
                      isUrgent: eventsData.items[index].isUrgent,
                    ),
                    Divider()
                  ],
                )),
      ),
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
