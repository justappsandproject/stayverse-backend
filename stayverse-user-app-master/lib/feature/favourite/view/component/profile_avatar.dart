import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final bool isVerified;
  final double size;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    this.isVerified = false,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.teal[200],
          backgroundImage: AssetImage(imageUrl),
        ),
        if (isVerified)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified,
                color: Colors.teal[400],
                size: size * 0.3,
              ),
            ),
          ),
      ],
    );
  }
}
