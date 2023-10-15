import 'package:flutter/material.dart';

class RightAlignedTextButton extends StatelessWidget {
  const RightAlignedTextButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final VoidCallback? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(onPressed: onPressed, child: Text(title)),
    );
  }
}
