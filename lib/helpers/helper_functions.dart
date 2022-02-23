import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String stringifyDate(DateTime date) {
  return '${date.day.toString()}/${date.month.toString()}/${date.year.toString()}';
}

SnackBar buildSnackBar(
    {required BuildContext context,
    required String text,
    String? actionLabel,
    Function? actionHandler}) {
  final device = MediaQuery.of(context);

  SnackBarAction createAction({String? actionLabel, Function? actionHandler}) {
    actionHandler ??= ScaffoldMessenger.of(context).hideCurrentSnackBar;
    actionLabel ??= 'Cerrar';
    return SnackBarAction(label: actionLabel, onPressed: () => actionHandler);
  }

  return SnackBar(
    width: device.size.width * 0.6,
    content: Text(
      text,
      style: GoogleFonts.raleway(fontSize: 15),
    ),
    duration: const Duration(seconds: 5),
    elevation: 5,
    behavior: SnackBarBehavior.floating,
    action:
        createAction(actionLabel: actionLabel, actionHandler: actionHandler),
  );
}

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: Colors.blue,
    title: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: Colors.white38,
        child: Image.asset("lib/assets/logo_ceib.png"),
      ),
    ),
    centerTitle: true,
  );
}

String _removeInitialHashtagsAndHyphens(String string) {
  //Para evitar uso indeseado de markdown
  final _str = string.trim();
  if (_str.startsWith('#')) {
    return _removeInitialHashtagsAndHyphens(_str.substring(1));
  }
  if (_str.startsWith('---')) {
    return _removeInitialHashtagsAndHyphens(_str.substring(3));
  }
  return _str;
}

String avoidHeadings(String? string) {
  if (string == null) return '';
  final _str = StringBuffer();
  final _disectedStr = string.split('\n');
  for (final element in _disectedStr) {
    _str.write('${_removeInitialHashtagsAndHyphens(element)}\n');
  }
  return _str.toString();
}
