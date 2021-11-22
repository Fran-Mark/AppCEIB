import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../helpers/vertical_text_line.dart';

class ErrorScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ErrorScreenState();
  }
}

class _ErrorScreenState extends State<ErrorScreen> {
  final List<Widget> _verticalLines = [];
  late Timer timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _verticalLines);
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _verticalLines.add(_getVerticalTextLine(context));
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget _getVerticalTextLine(BuildContext context) {
    final Key key = GlobalKey();
    return Positioned(
      key: key,
      left: Random().nextDouble() * MediaQuery.of(context).size.width,
      child: VerticalTextLine(
          onFinished: () {
            setState(() {
              _verticalLines.removeWhere((element) {
                return element.key == key;
              });
            });
          },
          speed: 1 + Random().nextDouble() * 9,
          maxLength: Random().nextInt(10) + 5),
    );
  }
}
