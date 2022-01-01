import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/widgets/reservation_category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../extensions/user_extension.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _device = MediaQuery.of(context);
    final _itemsPerRow = _device.size.width > 700
        ? _device.size.width > 1400
            ? 3
            : 2
        : 1;
    return FutureBuilder(
        future: _user?.isSportsEditor(),
        builder: (context, isEditor) {
          final _isSportsEditor = isEditor.data as bool?;
          if (_isSportsEditor != null) {
            return GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _itemsPerRow,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 40),
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(30),
              children: [
                if (_isSportsEditor)
                  const ReservationCategory(
                    title: "Bicis-admin",
                    imageName: "bicis",
                  )
                else
                  const ReservationCategory(
                    title: "Bicis",
                    imageName: "bicis",
                    enabled: false,
                  ),
                const ReservationCategory(
                  title: "Lavarropas",
                  imageName: "lavarropas",
                  enabled: false,
                ),
                const ReservationCategory(
                  title: "Ski",
                  imageName: 'snow',
                  enabled: false,
                ),
                const ReservationCategory(
                  title: "Raquetas",
                  imageName: "raquetas",
                  enabled: false,
                )
              ],
            );
          } else
            return const Center(child: CircularProgressIndicator.adaptive());
        });
  }
}
