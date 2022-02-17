import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/screens/auth/login_screen.dart';
import 'package:ceib/screens/initial_tabs/main_screen.dart';
import 'package:ceib/widgets/loading_ceib.dart';
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
    //_reloadData(_authProvider);
    if (user == null) {
      return const LoginScreen();
    }
    if (user.emailVerified) {
      return const MainScreen();
    } else {
      final device = MediaQuery.of(context);
      return Scaffold(
          appBar: AppBar(
            title: const Text("Verificando..."),
            actions: const [LogOutButton()],
          ),
          body: Center(
              child: SizedBox(
                  height: device.size.height * 0.8,
                  width: device.size.width * 0.7,
                  child: Column(children: [
                    const LoadingCEIB(),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Verifica tu mail para continuar ${user.displayName}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(fontSize: 30),
                    ),
                    TextButton(
                        onPressed: () {
                          _reloadData(_authProvider);
                        },
                        child: _authProvider.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Recargar",
                                style: TextStyle(fontSize: 15),
                              ))
                  ]))));
    }
  }
}
