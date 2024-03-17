import 'package:flutter/material.dart';

class Utilities {
  Utilities._();

  static displayMessage(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }
}
