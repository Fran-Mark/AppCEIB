import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Posteo extends StatelessWidget {
  const Posteo(
      {Key? key,
      required this.data,
      required this.date,
      required this.email,
      required this.likeCount})
      : super(key: key);
  final String? data;
  final DateTime? date;
  final String? email;
  final int? likeCount;
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _userData = Provider.of<UserData>(context);
    String? _imgURL = _userData.imageURL;
    _imgURL ??=
        'https://static.planetminecraft.com/files/resource_media/screenshot/1244/steve_4048323.jpg';
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(_imgURL),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${_user?.displayName}",
                                  style: GoogleFonts.barlowSemiCondensed(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 8,
                              ),
                              MarkdownBody(
                                data: avoidHeadings(data),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const IconButton(
                        onPressed: null,
                        icon: Icon(CupertinoIcons.bubble_left_bubble_right)),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(CupertinoIcons.heart)),
                        if (likeCount != 0 && likeCount != null)
                          Text('$likeCount'),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
