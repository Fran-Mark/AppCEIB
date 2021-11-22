import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog(
      {Key? key,
      required this.title,
      required this.content,
      required this.handler})
      : super(key: key);

  final String title;
  final String content;
  final void Function() handler;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: handler,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromRGBO(255, 230, 234, 1))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Text("Sí"),
                ))),
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'No');
            },
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 230, 234, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Text(
                  "No",
                ),
              ),
            ))
      ],
    );
  }
}
