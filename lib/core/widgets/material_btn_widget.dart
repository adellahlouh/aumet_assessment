import 'package:flutter/material.dart';

Widget btnWidget({required String title, required VoidCallback onTap}) {
  return MaterialButton(
    color: Colors.blue,
    onPressed: () => onTap(),
    child: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
  );
}