import 'dart:async';
import 'package:ceib/providers/connectivity.dart';
import 'package:ceib/providers/storage.dart';
import 'package:ceib/screens/auth/login_screen.dart';
import 'package:ceib/screens/auth/reset_password_screen.dart';
import 'package:ceib/screens/categories/bicis_screens/bicis_screen.dart';
import 'package:ceib/screens/categories/bicis_screens/bicis_screen_admin.dart';
import 'package:ceib/screens/categories/lavarropas_screen.dart';
import 'package:ceib/screens/categories/raquetas_screen.dart';
import 'package:ceib/screens/categories/ski_screen.dart';
import 'package:ceib/screens/edit_event_screen.dart';
import 'package:ceib/screens/initial_tabs/main_screen.dart';
import 'package:ceib/screens/no_connection_screen.dart';
import 'package:ceib/services/auth/auth_service.dart';
import 'package:ceib/services/notifications/notifications_wrapper.dart';
import 'package:ceib/widgets/error_screen_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './providers/events.dart';
import './services/sheets/sheets_api.dart';
import 'providers/auth_service.dart';
import 'providers/bicis.dart';
import 'screens/auth/register_screen.dart';
import 'screens/new_event.dart';

//Futura implementación de handler para notificaciones de background
Future<void> _backgroundHandler(RemoteMessage msg) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  final _isConnected = await connectionStatus.checkConnection();
  if (_isConnected) {
    try {
      await SheetsAPI.init();
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
      runApp(MyApp());
    } on Exception {
      runApp(const NoConnectionWidget());
    }
  } else {
    runApp(const NoConnectionWidget());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Storage()),
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
        home: const NotificationsWrapper(),
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
          return MaterialPageRoute(builder: (_) => ErrorScreenWrapper());
        },
      ),
    );
  }
}
