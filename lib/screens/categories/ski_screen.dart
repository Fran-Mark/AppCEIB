import 'package:flutter/material.dart';

class SkiScreen extends StatelessWidget {
  const SkiScreen({Key? key}) : super(key: key);
  static const routeName = '/ski-screen';
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "Ski",
      child: Scaffold(
        body: Container(
            child: Center(
          child: Text("Ski"),
        )),
      ),
    );
  }
}
