import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/services/sheets/sheets_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Debt extends StatelessWidget {
  const Debt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _userDebt = SheetsAPI.getDebt(_user!.email!);
    return FutureBuilder(
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
        });
  }
}
