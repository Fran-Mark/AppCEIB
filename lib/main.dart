import 'package:ceib/auth/auth_service.dart';
import 'package:ceib/auth/auth_wrapper.dart';
import 'package:ceib/screens/categories/bicis_screen.dart';
import 'package:ceib/screens/categories/raquetas_screen.dart';
import 'package:ceib/screens/categories/ski_screen.dart';
import 'package:ceib/screens/categories/lavarropas_screen.dart';
import 'package:ceib/screens/edit_event_screen.dart';
import 'package:ceib/screens/error_screen.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/screens/auth/login_screen.dart';
import 'package:ceib/screens/initial_tabs/main_screen.dart';
import 'package:ceib/screens/auth/reset_password_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import './providers/events.dart';
import 'screens/new_event.dart';
import 'screens/auth/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _init = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return ErrorWidget();
          else if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthServices>.value(
                    value: AuthServices()),
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
                home: AuthWrapper(),
                routes: {
                  NewEvent.routeName: (context) => NewEvent(),
                  LoginScreen.routeName: (context) => LoginScreen(),
                  RegisterScreen.routeName: (context) => RegisterScreen(),
                  MainScreen.routeName: (context) => MainScreen(),
                  ResetPasswordScreen.routeName: (context) =>
                      ResetPasswordScreen(),
                  EditEvent.routeName: (context) => EditEvent(),
                  LavarropasScreen.routeName: (context) => LavarropasScreen(),
                  BicisScreen.routeName: (context) => BicisScreen(),
                  SkiScreen.routeName: (context) => SkiScreen(),
                  RaquetasScreen.routeName: (context) => RaquetasScreen(),
                },
                onUnknownRoute: (_) {
                  return MaterialPageRoute(builder: (_) => ErrorWidget());
                },
              ),
            );
          } else
            return Loading();
        });
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

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
