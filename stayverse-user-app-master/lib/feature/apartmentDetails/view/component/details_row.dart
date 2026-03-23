import 'package:flutter/material.dart';
import 'package:stayverse/core/config/dependecies.dart';

class DetailRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;

  const DetailRow({
    super.key,
    this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 8),
          ],
          Text(
            '$label: ',
            style: $styles.text.body.copyWith(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: $styles.text.body.copyWith(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
