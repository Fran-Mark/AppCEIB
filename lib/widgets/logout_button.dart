import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/widgets/my_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthServices>(context);

    Future<void> _logOut(AuthServices authService) async {
      await authService.logout();
      Navigator.of(context).pop();
    }

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Color.fromRGBO(255, 230, 234, 1))),
          child: Text('Cerrar sesión'),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MyAlertDialog(
                    title: "Cerrar sesión",
                    content: "Seguro que querés cerrar sesión?",
                    handler: () => _logOut(_authService),
                  );
                });
          },
        ));
  }
}
