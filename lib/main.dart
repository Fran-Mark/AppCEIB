import 'package:ceib/auth/auth_service.dart';
import 'package:ceib/auth/auth_wrapper.dart';
import 'package:ceib/screens/edit_event_screen.dart';
import 'package:ceib/screens/error_screen.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/screens/login_screen.dart';
import 'package:ceib/screens/main_screen.dart';
import 'package:ceib/screens/reset_password_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import './providers/events.dart';
import 'screens/new_event.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _init = Firebase.initializeApp();
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return ErrorWidget();
          else if (snapshot.hasData) {
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
