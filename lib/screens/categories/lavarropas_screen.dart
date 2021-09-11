import 'package:flutter/material.dart';

class LavarropasScreen extends StatelessWidget {
  const LavarropasScreen({Key? key}) : super(key: key);
  static const routeName = '/lavarropas-screen';
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "Lavarropas",
      child: Scaffold(
        body: Container(
            child: Center(
          child: Text("Lavarropas"),
        )),
      ),
    );
  }
}
