import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/services/sheets/sheets_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Debt extends StatefulWidget {
  const Debt({Key? key}) : super(key: key);

  @override
  State<Debt> createState() => _DebtState();
}

class _DebtState extends State<Debt> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _userDebt = SheetsAPI.updateDebt(_user!.email!);
    final _cachedDebt = SheetsAPI.debt;

    return FutureBuilder(
        future: _userDebt,
        builder: (context, snapshot) {
          if (snapshot.hasData || _cachedDebt != null) {
            if (_cachedDebt == '0' || _cachedDebt == "-0.0")
              return Text(
                "No tenés deuda! :)",
                style: GoogleFonts.hindMadurai(),
              );
            else
              return Text("Tu deuda es: \$$_cachedDebt",
                  style: GoogleFonts.hindMadurai(
                    color: Colors.red,
                  ));
          } else
            return const CircularProgressIndicator();
        });
  }
}
