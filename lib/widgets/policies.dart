import 'package:ceib/assets/terms_and_conditions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/helper_functions.dart';

class Policies extends StatelessWidget {
  const Policies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Al hacerte una cuenta estás aceptando los siguientes ",
                style: GoogleFonts.montserrat(color: Colors.black),
                children: [
                  TextSpan(
                      text: "Términos y Condiciones ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          policyDialog(context, termsAndConditions);
                        }),
                  TextSpan(text: "y la siguiente "),
                  TextSpan(
                      text: "Política de Privacidad.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          const urlString =
                              "https://www.termsfeed.com/live/6b9c0fef-ed9f-4b2f-9b90-b01ebdad2f28";
                          if (await canLaunch(urlString)) {
                            launch(urlString);
                          } else
                            ScaffoldMessenger.of(context).showSnackBar(
                                buildSnackBar(
                                    context: context,
                                    text: "No anda el link :("));
                        })
                ])),
        MarkdownBody(
            styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.hindMadurai(fontSize: 15.5),
                a: GoogleFonts.hindMadurai(
                    fontSize: 15.5,
                    color: Colors.red,
                    decoration: TextDecoration.none)),
            onTapLink: (text, href, title) async {
              if (href != null) {
                if (await canLaunch(href)) {
                  await launch(href);
                }
              } else
                ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
                    context: context, text: "No anda el link :("));
            },
            data:
                "Esta app es de [código abierto](https://github.com/Fran-Mark/AppCEIB).")
      ],
    );
  }

  Future<dynamic> policyDialog(BuildContext context, String terms) {
    return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white38,
                    child: Image.asset("lib/assets/logo_ceib.png"),
                  ),
                  Text(
                    "App del CEIB",
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Markdown(
                  data: terms,
                  physics: BouncingScrollPhysics(),
                ),
              ),
            ),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("ACEPTAR"))
          ],
        ),
      ),
    );
  }
}
