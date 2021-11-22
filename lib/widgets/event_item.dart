import 'package:ceib/models/event.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../extensions/datetime_extension.dart';

class EventItem extends StatelessWidget {
  const EventItem({required this.event});
  final Event event;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
              border: event.isUrgent
                  ? Border.all(color: Colors.red, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          event.title,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.alfaSlabOne(fontSize: 20),
                        ),
                      ),
                    ),
                    if (event.isUrgent)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.red),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "IMPORTANTE",
                            style: GoogleFonts.secularOne(color: Colors.white),
                          ),
                        ),
                      )
                    else
                      Container()
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    event.date.formatDate(),
                    style: GoogleFonts.hindMadurai(),
                  ),
                ),
              ),
              Row(children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: Text(
                          event.description,
                          style: GoogleFonts.hindMadurai(),
                        ))),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
