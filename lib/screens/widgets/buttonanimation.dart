import 'package:flutter/material.dart';

class ButtonAnimation extends StatefulWidget {
  const ButtonAnimation({
    Key? key,
    this.animationWidget,
    required this.onpress,
  }) : super(key: key);
  final Widget? animationWidget;
  final void Function()? onpress;
  @override
  State<ButtonAnimation> createState() => _ButtonAnimationState();
}

class _ButtonAnimationState extends State<ButtonAnimation>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  // final IconData mainIcon;
  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTap: widget.onpress != null ? tapDown : null,
      onTapDown: widget.onpress != null ? _tapDown : null,
      // onTapUp: _tapUp,
      child: Transform.scale(
        scale: _scale,
        child: widget.animationWidget,
      ),
    );
  }

  Future<void> _tapDown(
    TapDownDetails details,
  ) async {
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 50), () {
      _controller.reverse();
    });
    // widget.onpress();
  }

  void tapDown() async {
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 50), () {
      _controller.reverse();
    });
    if (widget.onpress != null) {
      widget.onpress!();
    }
  }

  // void _tapUp(TapUpDetails details) {
  //   _controller.reverse();
  // }
}
