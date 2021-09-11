import 'dart:ui';
import 'package:outlined_text/outlined_text.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReservationCategory extends StatelessWidget {
  const ReservationCategory(
      {Key? key, required String this.title, this.imageName})
      : super(key: key);
  final title;
  final imageName;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/' + title.toLowerCase() + '-screen');
      },
      child: Hero(
        tag: title,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black)),
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'lib/assets/$imageName.gif',
                    fit: BoxFit.fill,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  ),
                ),
                Image.asset(
                  'lib/assets/$imageName.gif',
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: OutlinedText(
                    text: Text(
                      title,
                      style: GoogleFonts.titilliumWeb(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    strokes: [
                      OutlinedTextStroke(color: Colors.black, width: 5)
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
