import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LavarropasItem extends StatelessWidget {
  const LavarropasItem({Key? key, required this.number}) : super(key: key);
  final String number;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 195,
          width: 150,
          alignment: AlignmentDirectional.bottomCenter,
          child: Image.asset(
            'lib/assets/lavarropas_icon.png',
          ),
        ),
        Text(number)
      ],
    );
  }
}
