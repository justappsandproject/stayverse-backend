import 'package:flutter/material.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/shared/buttons.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color textColor;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBtn.from(
      onPressed: onPressed,
      text: text,
      textStyle: $styles.text.title2.copyWith(
        fontSize: 12,
        color: Colors.black,
        height: 1.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    );
  }
}
