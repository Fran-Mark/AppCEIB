import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String stringifyDate(DateTime date) {
  return date.day.toString() +
      '/' +
      date.month.toString() +
      '/' +
      date.year.toString();
}

SnackBar buildSnackBar(
    {required BuildContext context,
    required String text,
    String? actionLabel,
    Function? actionHandler}) {
  final device = MediaQuery.of(context);

  SnackBarAction createAction(String? actionLabel, Function? actionHandler) {
    if (actionLabel == null || actionHandler == null) {
      actionLabel = 'Cerrar';
      actionHandler = ScaffoldMessenger.of(context).hideCurrentSnackBar;
    }
    return SnackBarAction(label: actionLabel, onPressed: () => actionHandler);
  }

  return SnackBar(
    width: device.size.width * 0.6,
    content: Text(
      text,
      style: GoogleFonts.raleway(fontSize: 15),
    ),
    duration: Duration(seconds: 5),
    elevation: 5,
    behavior: SnackBarBehavior.floating,
    action: createAction(actionLabel, actionHandler),
  );
}
