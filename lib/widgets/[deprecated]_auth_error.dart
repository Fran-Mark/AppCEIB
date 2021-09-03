import 'package:flutter/material.dart';

class AuthError extends StatelessWidget {
  const AuthError({Key? key, this.authProvider}) : super(key: key);
  final authProvider;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        authProvider.errorMessage,
        style: TextStyle(color: Colors.white, shadows: <Shadow>[
          // Shadow(
          //   offset: Offset(10.0, 10.0),
          //   blurRadius: 3.0,
          //   color: Color.fromARGB(255, 0, 0, 0),
          // ),
          Shadow(
            offset: Offset(10.0, 10.0),
            blurRadius: 8.0,
            color: Color.fromARGB(125, 0, 0, 255),
          ),
        ]),
      ),
      leading: Icon(
        Icons.error,
        color: Colors.white,
      ),
      trailing: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          authProvider.errorMessage = "";
        },
      ),
    );
  }
}
