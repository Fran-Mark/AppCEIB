import 'dart:async';

import 'package:ceib/auth/auth_service.dart';
import 'package:ceib/auth/auth_wrapper.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/connectivity.dart';
import 'package:ceib/screens/auth/login_screen.dart';
import 'package:ceib/screens/auth/reset_password_screen.dart';
import 'package:ceib/screens/categories/bicis_screens/bicis_screen.dart';
import 'package:ceib/screens/categories/bicis_screens/bicis_screen_admin.dart';
import 'package:ceib/screens/categories/lavarropas_screen.dart';
import 'package:ceib/screens/categories/raquetas_screen.dart';
import 'package:ceib/screens/categories/ski_screen.dart';
import 'package:ceib/screens/edit_event_screen.dart';
import 'package:ceib/screens/error_screen.dart';
import 'package:ceib/screens/initial_tabs/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import './providers/events.dart';
import './sheets/sheets_api.dart';
import 'providers/bicis.dart';
import 'screens/auth/register_screen.dart';
import 'screens/new_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  final _isConnected = await connectionStatus.checkConnection();
  if (_isConnected) {
    try {
      await SheetsAPI.init();
      await Firebase.initializeApp();
      runApp(MyApp());
    } on Exception {
      runApp(const NoConnectionWidget());
    }
  } else {
    runApp(const NoConnectionWidget());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: ConnectionStatusSingleton.getInstance()),
        ChangeNotifierProvider.value(value: Bicis()),
        ChangeNotifierProvider<AuthServices>.value(value: AuthServices()),
        ChangeNotifierProvider.value(value: Events()),
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null)
      ],
      child: MaterialApp(
        title: 'App del CEIB',
        theme: ThemeData(
            primarySwatch: Colors.red,
            textTheme: TextTheme(
              button: GoogleFonts.raleway(fontWeight: FontWeight.bold),
            )),
        home: const AuthWrapper(),
        routes: {
          NewEvent.routeName: (context) => const NewEvent(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          MainScreen.routeName: (context) => const MainScreen(),
          ResetPasswordScreen.routeName: (context) =>
              const ResetPasswordScreen(),
          EditEvent.routeName: (context) => const EditEvent(),
          LavarropasScreen.routeName: (context) => const LavarropasScreen(),
          BicisScreen.routeName: (context) => const BicisScreen(),
          BicisAdminScreen.routeName: (context) => const BicisAdminScreen(),
          SkiScreen.routeName: (context) => const SkiScreen(),
          RaquetasScreen.routeName: (context) => const RaquetasScreen(),
        },
        onUnknownRoute: (_) {
          return MaterialPageRoute(builder: (_) => ErrorWidget());
        },
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: ErrorScreen(),
      ),
    );
  }
}

class NoConnectionWidget extends StatefulWidget {
  const NoConnectionWidget({Key? key}) : super(key: key);

  @override
  State<NoConnectionWidget> createState() => _NoConnectionWidgetState();
}

class _NoConnectionWidgetState extends State<NoConnectionWidget> {
  bool _isLoading = false;
  late StreamSubscription<dynamic> _connectionStream;
  bool _hasConnection = ConnectionStatusSingleton.getInstance().hasConnection;
  @override
  void initState() {
    _connectionStream = ConnectionStatusSingleton.getInstance()
        .connectionChange
        .listen((event) {
      _hasConnection = event as bool;
      if (_hasConnection) main();
    });
    super.initState();
  }

  @override
  void dispose() {
    _connectionStream.cancel();
    super.dispose();
  }

  void _toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.red,
          textTheme: TextTheme(
            button: GoogleFonts.raleway(fontWeight: FontWeight.bold),
          )),
      home: Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.transparent,
                  child: Image.asset("lib/assets/logo_ceib.png"),
                ),
                LoadingDoubleFlipping.circle(
                  borderSize: 8,
                  size: 120,
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.red[200]!,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Esperando conexión",
                style: GoogleFonts.hindMadurai(fontSize: 22),
              ),
            ),
            if (!_isLoading)
              TextButton(
                  onPressed: () async {
                    _toggleIsLoading();
                    await main().then((value) => _toggleIsLoading());
                  },
                  child: Text(
                    "Intentar de vuelta",
                    style: GoogleFonts.hindMadurai(fontSize: 15),
                  )),
            if (_isLoading) const CircularProgressIndicator.adaptive()
          ],
        ),
      ),
    );
  }
}
