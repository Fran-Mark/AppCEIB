import 'dart:async';

import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/connectivity.dart';
import 'package:ceib/widgets/my_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogOutButton extends StatefulWidget {
  const LogOutButton({
    Key? key,
  }) : super(key: key);

  @override
  State<LogOutButton> createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  Color _backgroundColor = const Color.fromRGBO(255, 230, 234, 1);

  Color _textColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthServices>(context);
    final _hasConnection =
        Provider.of<ConnectionStatusSingleton>(context).hasConnection;

    if (_hasConnection) {
      _backgroundColor = const Color.fromRGBO(255, 230, 234, 1);
      _textColor = Colors.red;
    } else {
      _backgroundColor = Colors.grey[500]!;
      _textColor = Colors.grey[200]!;
    }

    Future<void> _logOut(AuthServices authService) async {
      await authService.logout();
      Navigator.of(context).pop();
    }

    void _handler() {
      if (_hasConnection) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyAlertDialog(
                title: "Cerrar sesión",
                content: "Seguro que querés cerrar sesión?",
                handler: () => _logOut(_authService),
              );
            });
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(_backgroundColor)),
        onPressed: _handler,
        child: Text(
          'Cerrar sesión',
          style: TextStyle(color: _textColor),
        ),
      ),
    );
  }
}
