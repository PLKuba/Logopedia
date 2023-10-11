import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

showToast(String text,
    {bool shortToast = true,
    fromBottom = true,
    Color color = const Color.fromARGB(0, 163, 27, 27),
    Color textColor = const Color.fromARGB(255, 72, 136, 81)}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: shortToast ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: fromBottom ? ToastGravity.BOTTOM : ToastGravity.TOP,
      backgroundColor: color,
      textColor: textColor,
      fontSize: 16.0);
}
