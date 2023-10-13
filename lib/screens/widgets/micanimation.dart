import 'package:flutter/material.dart';

class MicAnimation extends StatefulWidget {
  const MicAnimation({super.key});

  @override
  State<StatefulWidget> createState() => _MicAnimationState();
}

class _MicAnimationState extends State<MicAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + _controller.value * 0.2, // Adjust scaling factor as needed
          child: Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.mic,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
