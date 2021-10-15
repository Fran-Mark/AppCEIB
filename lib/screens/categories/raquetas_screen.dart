import 'package:flutter/material.dart';

class RaquetasScreen extends StatelessWidget {
  const RaquetasScreen({Key? key}) : super(key: key);
  static const routeName = '/raquetas-screen';
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "Raquetas",
      child: Scaffold(
        body: Container(
            child: Center(
          child: Text("Raquetas"),
        )),
      ),
    );
  }
}
