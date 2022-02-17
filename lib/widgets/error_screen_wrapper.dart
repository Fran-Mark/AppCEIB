import 'package:ceib/screens/error_screen.dart';
import 'package:flutter/material.dart';

class ErrorScreenWrapper extends StatelessWidget {
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
