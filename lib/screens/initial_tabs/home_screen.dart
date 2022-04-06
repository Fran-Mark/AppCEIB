import 'package:ceib/screens/categories/bicis_screens/bicis_screen.dart';
import 'package:ceib/services/notifications/notifications.dart';
import 'package:ceib/widgets/debt.dart';
import 'package:ceib/widgets/display_name.dart';
import 'package:ceib/widgets/logout_button.dart';
import 'package:ceib/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showNoti() {
    LocalNotificationService.displayLocalNotification("Hola", "Mama",
        payload: BicisScreen.routeName);
    print("noti");
    return;
  }

  @override
  Widget build(BuildContext context) {
    final _device = MediaQuery.of(context);

    return Center(
      child: Container(
        height: _device.size.height * 0.7,
        width: _device.size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    ProfilePicture(),
                    SizedBox(
                      height: 40,
                    ),
                    Center(child: DisplayName()),
                  ],
                )),
                Flexible(
                    child: Column(
                  children: const [Divider(), Debt()],
                )),
              ],
            ),
            Positioned(
                bottom: 50,
                child: TextButton(onPressed: _showNoti, child: Text("Noit"))),
            const LogOutButton(),
          ],
        ),
      ),
    );
  }
}
