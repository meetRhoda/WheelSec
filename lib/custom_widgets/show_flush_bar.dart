import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../others/constants.dart';

showFlushBar({required BuildContext context, required String title,
  required String message, required String state}) {
  Color color;
  Icon icon = const Icon(
    Icons.report,
    color: Colors.white,
  );

  switch (state) {
    case "success":
      color = success;
      icon = const Icon(Icons.check_circle, color: Colors.white,);
      break;
    case "warning":
      color = warning;
      icon = const Icon(Icons.report, color: Colors.white,);
      break;
    case "error":
      color = error;
      icon = const Icon(Icons.error, color: Colors.white,);
      break;
    case "info":
      color = primary;
      icon = Icon(Icons.info, color: onPrimary,);
      break;
    default:
      color = primary;
      icon = Icon(Icons.info, color: onPrimary,);
  }

  Flushbar(
    title: title,
    titleColor: Colors.white,
    message: message,
    messageColor: Colors.white,
    duration: const Duration(seconds: 6),
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.GROUNDED,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticInOut,
    backgroundColor: color,
    isDismissible: false,
    icon: icon,
  ).show(context);

  FocusScope.of(context).unfocus();
}