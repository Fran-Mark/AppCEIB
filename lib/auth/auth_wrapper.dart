import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/screens/login_screen.dart';
import 'package:ceib/screens/main_screen.dart';
import 'package:ceib/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  Future<void> _reloadData(AuthServices authProvider) async {
    final user = authProvider.firebaseAuth.currentUser;
    if (user != null) {
      await authProvider.reloadData(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthServices>(context);
    final user = _authProvider.firebaseAuth.currentUser;
    if (user == null) {
      return LoginScreen();
    }
    if (user.emailVerified) {
      return MainScreen();
    } else {
      final device = MediaQuery.of(context);
      return Scaffold(
          appBar: AppBar(
            title: Text("Verificando..."),
            actions: [LogOutButton()],
          ),
          body: Center(
              child: SizedBox(
                  height: device.size.height * 0.8,
                  width: device.size.width * 0.7,
                  child: Column(children: [
                    Text(
                      "Verifica tu mail para continuar ${user.displayName}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(fontSize: 50),
                    ),
                    TextButton(
                        onPressed: () {
                          _reloadData(_authProvider);
                        },
                        child: _authProvider.isLoading
                            ? CircularProgressIndicator()
                            : Text("Recargar"))
                  ]))));
    }
  }
}
