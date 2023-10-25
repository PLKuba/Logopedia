import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

showToast(String text,
    {bool shortToast = true,
    fromBottom = true,
    Color color = Colors.black,
    Color textColor = Colors.white,}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: shortToast ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: fromBottom ? ToastGravity.BOTTOM : ToastGravity.TOP,
      backgroundColor: color,
      textColor: textColor,
      fontSize: 16.0);
}
