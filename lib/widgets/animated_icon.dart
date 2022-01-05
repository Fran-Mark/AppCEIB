import 'package:flutter/material.dart';

class MyAnimatedIcon extends StatefulWidget {
  const MyAnimatedIcon({Key? key, required this.icon, this.color = Colors.red})
      : super(key: key);

  final AnimatedIconData icon;
  final Color color;
  @override
  _MyAnimatedIconState createState() => _MyAnimatedIconState();
}

class _MyAnimatedIconState extends State<MyAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isAnimationDone = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!_isAnimationDone) _animationController.forward();
        if (_isAnimationDone) _animationController.reverse();
        _isAnimationDone = !_isAnimationDone;
      },
      child: AnimatedIcon(
        size: 50,
        color: widget.color,
        icon: widget.icon,
        progress: _animationController,
      ),
    );
  }
}
