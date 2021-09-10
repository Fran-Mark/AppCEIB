import 'package:ceib/widgets/reservation_category_item.dart';
import 'package:flutter/material.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _device = MediaQuery.of(context);
    final _itemsPerRow = _device.orientation == Orientation.portrait ? 1 : 2;
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _itemsPerRow,
          crossAxisSpacing: 40,
          mainAxisSpacing: 40),
      children: [
        ReservationCategory(
          title: "Bicis",
          imageName: "bicis",
        ),
        ReservationCategory(
          title: "Lavarropas",
          imageName: "lavarropas",
        ),
        ReservationCategory(
          title: "Ski/Snow",
          imageName: 'snow',
        ),
        ReservationCategory(
          title: "Raquetas",
          imageName: "raquetas",
        )
      ],
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(30),
    );
  }
}
