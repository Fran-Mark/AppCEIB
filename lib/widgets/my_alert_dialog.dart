import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  MyAlertDialog({Key? key, this.title, this.content, this.handler})
      : super(key: key);

  final title;
  final content;
  final handler;

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
                    border:
                        Border.all(color: Color.fromRGBO(255, 230, 234, 1))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Text(
                  "No",
                ),
              ),
            ))
      ],
    );
  }
}
