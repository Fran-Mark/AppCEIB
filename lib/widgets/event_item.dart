import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../extensions/datetime_extension.dart';

class EventItem extends StatelessWidget {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final bool isUrgent;

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isUrgent,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.alfaSlabOne(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  date.formatDate(),
                  style: GoogleFonts.hindMadurai(),
                ),
              ),
            ),
            Row(children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: Text(
                        description,
                        style: GoogleFonts.hindMadurai(),
                      ))),
            ])
          ],
        ),
      ),
    );
  }
}
