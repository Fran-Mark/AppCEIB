import 'package:flutter/material.dart';

class RaquetasScreen extends StatelessWidget {
  const RaquetasScreen({Key? key}) : super(key: key);
  static const routeName = '/raquetas-screen';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Raquetas"),
      ),
    );
  }
}
