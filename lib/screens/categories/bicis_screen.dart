import 'package:flutter/material.dart';

class BicisScreen extends StatelessWidget {
  const BicisScreen({Key? key}) : super(key: key);
  static const routeName = '/bicis-screen';
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "Bicis",
      child: Scaffold(
        body: Container(
            child: Center(
          child: Text("Bicis"),
        )),
      ),
    );
  }
}
