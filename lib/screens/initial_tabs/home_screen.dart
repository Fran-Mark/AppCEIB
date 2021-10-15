import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/sheets/sheets_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _device = MediaQuery.of(context);
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;

    if (_user == null) return Text("Hannah Montana");
    final _userDebt = SheetsAPI.getDebt(_user.email!);
    if (_user.displayName == null) {
      return Text("Jason Bourne");
    } else
      return Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Color.fromRGBO(255, 230, 234, 1), width: 10),
              borderRadius: BorderRadius.circular(20)),
          height: _device.size.height * 0.7,
          width: _device.size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _user.displayName!,
                style: GoogleFonts.raleway(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              Divider(),
              FutureBuilder(
                  future: _userDebt,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final _deuda = snapshot.data as String;
                      //La 2da condicion es por un bug, deberia poder removerse
                      if (_deuda == '0' || _deuda == "-0.0")
                        return Text("No tenés deuda! :)");
                      else
                        return Wrap(
                          children: [Text("Tu deuda es: "), Text("\$$_deuda")],
                        );
                    } else
                      return CircularProgressIndicator();
                  })
            ],
          ),
        ),
      );
  }
}
