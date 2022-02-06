import 'package:ceib/providers/posteos.dart';
import 'package:ceib/widgets/posteo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _posteos = Provider.of<Posteos>(context).getPosteos(1);
    return Stack(
      fit: StackFit.expand,
      children: [
        FutureBuilder(
            future: _posteos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final _posteosSnapshot = snapshot.data as List<Posteo>?;
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    if (_posteosSnapshot == null) return Container();
                    return _posteosSnapshot[index];
                  },
                  physics: const BouncingScrollPhysics(),
                );
              } else
                return const Center(
                    child: CircularProgressIndicator.adaptive());
            }),
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
