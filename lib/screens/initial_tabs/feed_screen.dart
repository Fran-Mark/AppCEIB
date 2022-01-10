import 'package:ceib/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const _str =
        "Hola quiero ver si puedo *escribir* en **markdown** www.markdown.com 🤌";
    return Center(
        child: Markdown(
            styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.hindMadurai(fontSize: 15.5),
                a: GoogleFonts.hindMadurai(
                    fontSize: 15.5,
                    color: Colors.red,
                    decoration: TextDecoration.none)),
            selectable: true,
            onTapLink: (text, href, title) async {
              if (href != null) {
                if (await canLaunch(href)) {
                  await launch(href);
                }
              } else
                ScaffoldMessenger.of(context).showSnackBar(
                    buildSnackBar(context: context, text: "No launchea"));
            },
            data: avoidHeadings(_str)));
  }
}
