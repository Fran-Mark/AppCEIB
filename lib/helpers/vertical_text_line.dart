import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class VerticalTextLine extends StatefulWidget {
  const VerticalTextLine(
      {required this.onFinished,
      this.speed = 20.0,
      this.maxLength = 10,
      Key? key})
      : super(key: key);

  final double speed;
  final int maxLength;
  final VoidCallback onFinished;

  @override
  _VerticalTextLineState createState() => _VerticalTextLineState();
}

class _VerticalTextLineState extends State<VerticalTextLine> {
  late int _maxLength;
  late Duration _stepInterval;
  final List<String> _characters = [];
  late Timer timer;

  @override
  void initState() {
    _maxLength = widget.maxLength;
    _stepInterval = Duration(milliseconds: 1000 ~/ widget.speed);
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    timer = Timer.periodic(_stepInterval, (timer) {
      final _random = Random();
      final String element = String.fromCharCode(_random.nextInt(512));

      // ignore: cast_nullable_to_non_nullable
      final box = context.findRenderObject() as RenderBox;

      if (box.size.height > MediaQuery.of(context).size.height * 1.5) {
        widget.onFinished();
        return;
      }

      setState(() {
        _characters.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<double> stops = [];
    List<Color> colors = [];

    double greenStart = 0.3;
    final double whiteStart = (_characters.length - 1) / (_characters.length);

    colors = [Colors.transparent, Colors.green, Colors.green, Colors.white];

    greenStart = (_characters.length - _maxLength) / _characters.length;

    stops = [0, greenStart, whiteStart, whiteStart];

    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: stops,
            colors: colors,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _getCharacters(),
        ));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  List<Widget> _getCharacters() {
    final List<Widget> textWidgets = [];

    for (final character in _characters) {
      textWidgets.add(Text(character,
          style: const TextStyle(fontFamily: "Monospace", fontSize: 14)));
    }

    return textWidgets;
  }
}
