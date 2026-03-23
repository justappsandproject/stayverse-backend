import 'package:flutter/material.dart';

class RouteErrorScreen extends StatelessWidget {
  final String? route;
  const RouteErrorScreen({super.key, this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$route Route does not exist',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}