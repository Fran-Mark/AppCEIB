import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/user_data.dart';
import 'package:ceib/screens/initial_tabs/events_screen.dart';
import 'package:ceib/screens/initial_tabs/feed_screen.dart';
import 'package:ceib/screens/initial_tabs/home_screen.dart';
import 'package:ceib/screens/initial_tabs/reservations_screen.dart';
import 'package:ceib/services/sheets/sheets_api.dart';
import 'package:ceib/widgets/loading_ceib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const routeName = 'main-screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final Future<bool> futureData;
  var _selected = 0;
  void _select(int index) {
    setState(() {
      _selected = index;
    });
  }

  Future<bool> _initUserData(String email) async {
    try {
      await UserData.getInstance().init();
      await SheetsAPI.updateDebt(email);
      return true;
    } on Exception catch (e) {
      //Esto se trigerea de manera azarosa
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    const _navigationHandler = {
      0: HomeScreen(),
      1: EventsScreen(),
      2: ReservationsScreen(),
      3: FeedScreen()
    };

    return FutureBuilder(
        future: _initUserData(_user!.email!),
        builder: (context, future) {
          if (future.data == true)
            return Scaffold(
              appBar: buildAppBar(),
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
                      icon: Icon(Icons.person, color: Colors.red),
                      label: "Feed")
                ],
              ),
              body: _navigationHandler[_selected],
            );
          if (future.data == false) {
            return Scaffold(
              appBar: buildAppBar(),
              body: Center(
                child: Text(
                  "Algo salió mal :(",
                  style: GoogleFonts.hindMadurai(fontSize: 50),
                ),
              ),
            );
          } else
            return Scaffold(
              appBar: buildAppBar(),
              body: const Center(child: LoadingCEIB()),
            );
        });
  }
}
