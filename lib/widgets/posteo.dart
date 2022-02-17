import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/widgets/like_for_posts.dart';
import 'package:ceib/widgets/my_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../providers/posteos.dart';

class Posteo extends StatelessWidget {
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

//   @override
//   State<Posteo> createState() => _PosteoState();
// }

// class _PosteoState extends State<Posteo> {
  @override
  Widget build(BuildContext context) {
    final _posteos = Provider.of<Posteos>(context);
    final _usersInfo = _posteos.cachedPosts;

    final _imgURL = _usersInfo?[postID]?['imgURL'] ??
        'https://static.planetminecraft.com/files/resource_media/screenshot/1244/steve_4048323.jpg';

    final _displayName = _usersInfo?[postID]?['displayName'] ?? "nulo";
    return FutureBuilder(
        future: _posteos.updateCachedData(),
        builder: (context, snapshot) {
          if (_usersInfo == null) {
            return SkeletonLoader(
                period: Duration(seconds: 2),
                // highlightColor: Colors.lightBlue[300]!,
                builder: PostLayout(
                  data: data,
                  displayName: _displayName,
                  imgURL: _imgURL,
                  isLiked: isLiked,
                  likeCount: likeCount,
                  postID: postID,
                  uid: uid,
                ));
          }
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
            child: PostLayout(
                data: data,
                displayName: _displayName,
                imgURL: _imgURL,
                isLiked: isLiked,
                likeCount: likeCount,
                postID: postID,
                uid: uid),

            // Card(
            //   elevation: 10,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10)),
            //   child: SizedBox(
            //     width: MediaQuery.of(context).size.width,
            //     child: Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               CircleAvatar(
            //                 radius: 30,
            //                 backgroundImage:
            //                     CachedNetworkImageProvider(_imgURL),
            //               ),
            //               const SizedBox(
            //                 width: 20,
            //               ),
            //               Flexible(
            //                 child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Text(_displayName,
            //                               style:
            //                                   GoogleFonts.barlowSemiCondensed(
            //                                       fontWeight:
            //                                           FontWeight.bold)),
            //                           if (uid == _user?.uid)
            //                             IconButton(
            //                                 constraints: const BoxConstraints(
            //                                     maxHeight: 25),
            //                                 onPressed: _confirmDelete,
            //                                 icon: const Icon(
            //                                   Icons.delete_outline_rounded,
            //                                 ))
            //                         ],
            //                       ),
            //                       const SizedBox(
            //                         height: 8,
            //                       ),
            //                       MarkdownBody(
            //                         data: avoidHeadings(data),
            //                       ),
            //                     ]),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             const IconButton(
            //                 onPressed: null,
            //                 icon: Icon(
            //                     CupertinoIcons.bubble_left_bubble_right)),
            //             Row(
            //               children: [
            //                 LikeButtonForPosts(
            //                     postID: postID,
            //                     likesCount: likeCount ?? 0,
            //                     isLiked: isLiked),
            //                 if (likeCount != 0 &&
            //                     likeCount != null)
            //                   Text(
            //                     '${likeCount}',
            //                     style: TextStyle(color: Colors.grey[600]),
            //                   ),
            //               ],
            //             )
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          );
        });
  }
}

class PostLayout extends StatelessWidget {
  const PostLayout(
      {Key? key,
      required this.imgURL,
      required this.displayName,
      required this.postID,
      required this.uid,
      required this.data,
      required this.likeCount,
      required this.isLiked})
      : super(key: key);
  final String imgURL;
  final String displayName;
  final String postID;
  final String uid;
  final String? data;
  final int? likeCount;
  final bool isLiked;
  @override
  Widget build(BuildContext context) {
    final _posteos = Provider.of<Posteos>(context);
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;

    Future<void> _deletePost() async {
      final _result = await _posteos.deletePost(postID);

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

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    backgroundImage: CachedNetworkImageProvider(imgURL),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(displayName,
                                  style: GoogleFonts.barlowSemiCondensed(
                                      fontWeight: FontWeight.bold)),
                              if (uid == _user?.uid)
                                IconButton(
                                    constraints:
                                        const BoxConstraints(maxHeight: 25),
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
                    LikeButtonForPosts(
                        postID: postID,
                        likesCount: likeCount ?? 0,
                        isLiked: isLiked),
                    if (likeCount != 0 && likeCount != null)
                      Text(
                        '$likeCount',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
