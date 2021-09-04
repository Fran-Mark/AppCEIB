import 'package:ceib/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context);
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
                  return AlertDialog(
                    title: Text("Cerrar sesión"),
                    content: Text("Seguro que querés cerrar sesión?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            _user.logout();
                            Navigator.pop(context, 'Si');
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color.fromRGBO(255, 230, 234, 1))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 15),
                                child: Text("Sí"),
                              ))),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'No');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 230, 234, 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15),
                              child: Text(
                                "No",
                              ),
                            ),
                          ))
                    ],
                  );
                });
          },
        ));
  }
}
