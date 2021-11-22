import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/widgets/lavarropas_item.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class LavarropasScreen extends StatefulWidget {
  const LavarropasScreen({Key? key}) : super(key: key);
  static const routeName = '/lavarropas-screen';

  @override
  State<LavarropasScreen> createState() => _LavarropasScreenState();
}

class _LavarropasScreenState extends State<LavarropasScreen> {
  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "Lavarropas",
        child: Scaffold(
            appBar: buildAppBar(),
            body: SafeArea(
              child: Column(
                children: [
                  Flexible(
                    flex: 10,
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 30,
                        runSpacing: 30,
                        children: const [
                          LavarropasItem(number: '1'),
                          LavarropasItem(number: '2'),
                          LavarropasItem(
                            number: '3',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          constraints: const BoxConstraints.expand(),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 2)),
                          child: Column(
                            children: [
                              const Text("Cuándo querés lavar?"),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const TextButton(
                                        onPressed: null,
                                        child: Text("Lo antes posible!")),
                                    TextButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyCalendar())),
                                        child: const Text("Elegir fecha"))
                                  ])
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            )));
  }
}

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  final _calendarController = CalendarController();
  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: SfCalendar(
            controller: _calendarController,
            view: CalendarView.week,
            //specialRegions: _getTimeRegions(),
            showWeekNumber: true,
            timeSlotViewSettings: const TimeSlotViewSettings(
              timeFormat: 'HH:mm',
              timeInterval: Duration(hours: 2),
              timeIntervalHeight:
                  -1, //Makes it fit on the screen (without scrolling)
            ),
            showNavigationArrow: true,
            appointmentBuilder: (context, cellDetail) {
              return Container(
                width: cellDetail.bounds.width,
                height: cellDetail.bounds.height,
                color: Colors.amber,
                child: const Text("HOLA"),
              );
            }));
  }
}
