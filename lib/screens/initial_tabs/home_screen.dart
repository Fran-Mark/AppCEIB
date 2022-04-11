import 'package:ceib/screens/categories/bicis_screens/bicis_screen.dart';
import 'package:ceib/services/notifications/notifications.dart';
import 'package:ceib/widgets/debt.dart';
import 'package:ceib/widgets/display_name.dart';
import 'package:ceib/widgets/logout_button.dart';
import 'package:ceib/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
          const LogOutButton(),
        ],
      ),
    );
  }
}
