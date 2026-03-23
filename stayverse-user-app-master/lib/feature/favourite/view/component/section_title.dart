import 'package:flutter/material.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/extension/extension.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: $styles.text.title2.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText!,
              style: $styles.text.title2.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: context.color.primary,
                height: 1.5,
              ),
            ),
          ),
      ],
    );
  }
}
