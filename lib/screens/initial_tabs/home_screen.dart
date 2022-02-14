import 'package:ceib/widgets/debt.dart';
import 'package:ceib/widgets/display_name.dart';
import 'package:ceib/widgets/logout_button.dart';
import 'package:ceib/widgets/profile_picture.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _device = MediaQuery.of(context);

    return Center(
      child: Container(
        // decoration: BoxDecoration(
        //     border: Border.all(
        //         color: const Color.fromRGBO(255, 230, 234, 1), width: 10),
        //     borderRadius: BorderRadius.circular(20)),
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
            const LogOutButton(),
          ],
        ),
      ),
    );
  }
}
