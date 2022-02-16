import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/other_users_info.dart';
import 'package:ceib/widgets/like_for_posts.dart';
import 'package:ceib/widgets/my_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/posteos.dart';

class Posteo extends StatefulWidget {
  const Posteo(
      {Key? key,
      required this.data,
      required this.date,
      required this.likeCount,
      required this.isLiked,
      required this.uid,
      required this.postID})
      : super(key: key);
  final String postID;
  final String? data;
  final DateTime? date;
  final String uid;

  final bool isLiked;
  final int? likeCount;

  @override
  State<Posteo> createState() => _PosteoState();
}

class _PosteoState extends State<Posteo> {
  @override
  Widget build(BuildContext context) {
    final _posteos = Provider.of<Posteos>(context);
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _future = _posteos.updateCachedData();
    final _usersInfo = _posteos.cachedPosts;

    Future<void> _deletePost() async {
      final _result = await _posteos.deletePost(widget.postID);

      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: _result));
      Navigator.of(context).pop();
    }

    void _confirmDelete() {
      showDialog(
          context: context,
          builder: (context) {
            return MyAlertDialog(
                title: "Borrar posteo",
                content: "Seguro que querés borrar el posteo?",
                handler: _deletePost);
          });
    }

    final _imgURL = _usersInfo?[widget.postID]?['imgURL'] ??
        'https://static.planetminecraft.com/files/resource_media/screenshot/1244/steve_4048323.jpg';

    final _displayName = _usersInfo?[widget.postID]?['displayName'] ?? "nulo";

    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (_usersInfo == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
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
                              backgroundImage:
                                  CachedNetworkImageProvider(_imgURL),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_displayName,
                                            style:
                                                GoogleFonts.barlowSemiCondensed(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        if (widget.uid == _user?.uid)
                                          IconButton(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 25),
                                              onPressed: _confirmDelete,
                                              icon: const Icon(
                                                Icons.delete_outline_rounded,
                                              ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    MarkdownBody(
                                      data: avoidHeadings(widget.data),
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
                              icon: Icon(
                                  CupertinoIcons.bubble_left_bubble_right)),
                          Row(
                            children: [
                              LikeButtonForPosts(
                                  postID: widget.postID,
                                  likesCount: widget.likeCount ?? 0,
                                  isLiked: widget.isLiked),
                              if (widget.likeCount != 0 &&
                                  widget.likeCount != null)
                                Text(
                                  '${widget.likeCount}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
