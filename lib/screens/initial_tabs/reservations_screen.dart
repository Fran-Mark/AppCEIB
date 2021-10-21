import 'package:ceib/widgets/reservation_category_item.dart';
import 'package:flutter/material.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _device = MediaQuery.of(context);
    final _itemsPerRow = _device.size.width > 700
        ? _device.size.width > 1400
            ? 3
            : 2
        : 1;
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _itemsPerRow,
          crossAxisSpacing: 40,
          mainAxisSpacing: 40),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(30),
      children: const [
        ReservationCategory(
          title: "Bicis",
          imageName: "bicis",
        ),
        ReservationCategory(
          title: "Lavarropas",
          imageName: "lavarropas",
        ),
        ReservationCategory(
          title: "Ski",
          imageName: 'snow',
        ),
        ReservationCategory(
          title: "Raquetas",
          imageName: "raquetas",
        )
      ],
    );
  }
}
