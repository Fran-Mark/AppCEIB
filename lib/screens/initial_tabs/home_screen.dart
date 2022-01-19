import 'dart:async';

import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/sheets/sheets_api.dart';
import 'package:ceib/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../extensions/user_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final _device = MediaQuery.of(context);
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;

    Future<String> _updateDisplayName(String _name) async {
      try {
        await _user!.updateDisplayName(_name);
        return "Nombre cambiado!";
      } catch (e) {
        return "Algo salió mal";
      }
    }

    Widget _editTitleTextField() {
      if (_editingController.text == "") {
        _editingController.text = _user!.displayName!;
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

                ScaffoldMessenger.of(context).showSnackBar(
                    buildSnackBar(context: context, text: _result));
              }
              _toggleEditing();
            },
            autofocus: true,
            controller: _editingController,
          ),
        );
      return InkWell(
          onTap: () async {
            final _isAllowed = await _user!.canChangeName();
            if (_isAllowed) {
              _toggleEditing();
            }
          },
          child: Text(
            _user!.displayName!,
            style: GoogleFonts.raleway(fontSize: 25),
            textAlign: TextAlign.center,
          ));
    }

    if (_user == null) return const Text("Hannah Montana");
    final _userDebt = SheetsAPI.getDebt(_user.email!);
    if (_user.displayName == null) {
      return const Text("Jason Bourne");
    } else
      return Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromRGBO(255, 230, 234, 1), width: 10),
              borderRadius: BorderRadius.circular(20)),
          height: _device.size.height * 0.7,
          width: _device.size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: _editTitleTextField()),
                  const Divider(),
                  FutureBuilder(
                      future: _userDebt,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final _deuda = snapshot.data as String?;
                          if (_deuda == '0' || _deuda == "-0.0")
                            return Text(
                              "No tenés deuda! :)",
                              style: GoogleFonts.hindMadurai(),
                            );
                          else
                            return Text("Tu deuda es: \$$_deuda",
                                style: GoogleFonts.hindMadurai(
                                  color: Colors.red,
                                ));
                        } else
                          return const CircularProgressIndicator();
                      }),
                ],
              ),
              const LogOutButton()
            ],
          ),
        ),
      );
  }
}
