import 'package:ceib/extensions/user_extension.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DisplayName extends StatefulWidget {
  const DisplayName({Key? key}) : super(key: key);

  @override
  _DisplayNameState createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  var _isEditingText = false;
  final _editingController = TextEditingController(text: "");

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditingText = !_isEditingText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;

    Future<String> _updateDisplayName(String _name) async {
      try {
        await _user!.updateDisplayName(_name);
        return "Nombre cambiado!";
      } catch (e) {
        return "Algo salió mal";
      }
    }

    if (_user!.displayName == null) {
      _updateDisplayName("Nombre desconocido");
    }
    if (_editingController.text == "") {
      _editingController.text = _user.displayName!;
    }
    if (_isEditingText)
      return Center(
        child: TextField(
          maxLength: 50,
          style: GoogleFonts.raleway(fontSize: 25),
          textAlign: TextAlign.center,
          onSubmitted: (newValue) async {
            if (newValue != "") {
              final _result = await _updateDisplayName(newValue);

              ScaffoldMessenger.of(context)
                  .showSnackBar(buildSnackBar(context: context, text: _result));
            }
            _toggleEditing();
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return InkWell(
        onTap: () async {
          final _isAllowed = await _user.canChangeName();
          if (_isAllowed) {
            _toggleEditing();
          }
        },
        child: Text(
          _user.displayName!,
          style: GoogleFonts.raleway(fontSize: 25),
          textAlign: TextAlign.center,
        ));
  }
}
