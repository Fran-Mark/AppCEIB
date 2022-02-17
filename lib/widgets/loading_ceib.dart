import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingCEIB extends StatelessWidget {
  const LoadingCEIB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.transparent,
          child: Image.asset("lib/assets/logo_ceib.png"),
        ),
        LoadingDoubleFlipping.circle(
          borderSize: 8,
          size: 120,
          backgroundColor: Colors.transparent,
          borderColor: Colors.red[200]!,
        ),
      ],
    );
  }
}
