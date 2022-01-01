import 'dart:ui';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outlined_text/outlined_text.dart';

class ReservationCategory extends StatelessWidget {
  const ReservationCategory(
      {Key? key,
      required this.title,
      required this.imageName,
      this.enabled = true})
      : super(key: key);
  final String title;
  final String imageName;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final _color = enabled ? Colors.transparent : Colors.grey;
    return InkWell(
        onTap: () {
          if (enabled) {
            Navigator.of(context).pushNamed('/${title.toLowerCase()}-screen');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                buildSnackBar(context: context, text: "No anda todavía"));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(),
          ),
          child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _color,
                BlendMode.saturation,
              ),
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
        ));
  }
}
