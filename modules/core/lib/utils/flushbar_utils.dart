import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarUtils {
  static void showFlushbar(
    BuildContext context, {
    Color? color,
    required String message,
  }) {
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color ?? Colors.red,
      duration: const Duration(seconds: 2),
    ).show(context);
  }
}
