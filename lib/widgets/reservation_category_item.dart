import 'package:ceib/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

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
        ScaffoldMessenger.of(context)
            .showSnackBar(buildSnackBar(context: context, text: "soy Maxi"));
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black)),
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            fit: StackFit.expand,
            children: [
              imageName != null
                  ? Image.asset(
                      "lib/assets/$imageName.gif",
                    )
                  : Container(),
              Text(title),
            ],
          )),
    );
  }
}
