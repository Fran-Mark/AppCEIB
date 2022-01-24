import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Text("User / name.surname / hora"),
                  const Divider(
                    thickness: 2,
                  ),
                  const Text("Posteo"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                              CupertinoIcons.bubble_left_bubble_right)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.heart))
                    ],
                  ),
                ],
              ),
            )),
        Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
                tooltip: "Postea algo",
                child: const Icon(CupertinoIcons.bubble_right_fill),
                onPressed: () {})),
      ],
    );
  }
}
