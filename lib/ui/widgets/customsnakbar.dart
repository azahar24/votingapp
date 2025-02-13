import 'package:flutter/material.dart';

void showSnackbarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
       margin: const EdgeInsets.only(bottom: 600,right: 20,left: 20),
    ),
  );
}

