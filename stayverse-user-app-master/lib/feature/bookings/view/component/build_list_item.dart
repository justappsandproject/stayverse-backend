import 'package:flutter/material.dart';

Widget buildListItem(String title, bool value) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Color(0xFFF7F7F7),
          width: 1.0,
        ),
      ),
    ),
    child: ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      trailing: IgnorePointer(
        ignoring: true,
        child: Switch(
          value: value,
          onChanged: (_) {},
          activeColor: Colors.amber[400],
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
    ),
  );
}
