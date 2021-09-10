import 'package:ceib/screens/events_screen.dart';
import 'package:ceib/screens/home_screen.dart';
import 'package:ceib/screens/reservations_screen.dart';
import 'package:ceib/widgets/logout_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);
  static const routeName = 'main-screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _selected = 0;
  void _select(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _navigationHandler = {
      0: HomeScreen(),
      1: EventsScreen(),
      2: ReservationsScreen(),
      3: Center(
        child: Text(
            "Como quieres que te quiera si el que quiero que me quiera no me quiere como quiero que me quiera"),
      )
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('CEIB'),
        centerTitle: true,
        actions: [
          LogOutButton(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        onTap: _select,
        selectedLabelStyle: const TextStyle(color: Colors.black),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.red),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.red,
            ),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.pedal_bike,
                color: Colors.red,
              ),
              label: "Reservas"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.red), label: "Mafalda")
        ],
      ),
      body: _navigationHandler[_selected],
    );
  }
}
