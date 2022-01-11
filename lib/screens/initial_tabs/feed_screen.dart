import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: const [
              Text("Bici 1"),
              Divider(
                color: Colors.red,
                thickness: 2,
              ),
              //TextButton(onPressed: () {}, child: Text("Reservar"))
              Text("Hola")
            ],
          ),
        ));
  }
}
