import 'package:ceib/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context);
    final user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    if (user == null) return Text("Hannah Montana");
    if (user.displayName == null) {
      return Text("Jason Bourne");
    } else
      return Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          height: device.size.height * 0.7,
          width: device.size.width * 0.8,
          child: Center(
            child: Text(
              user.displayName!,
              style: GoogleFonts.raleway(fontSize: 50),
            ),
          ),
        ),
      );
  }
}
