import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class PostCommentsScreen extends StatelessWidget {
  const PostCommentsScreen({Key? key}) : super(key: key);
  static const routeName = '/post-comments';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: CommentTreeWidget(
          Comment(
              avatar: 'null',
              userName: 'null',
              content: 'felangel made felangel/cubit_and_beyond public '),
          [
            Comment(
                avatar: 'null',
                userName: 'null',
                content: 'A Dart template generator which helps teams'),
            Comment(
                avatar: 'null',
                userName: 'null',
                content:
                    'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
            Comment(
                avatar: 'null',
                userName: 'null',
                content: 'A Dart template generator which helps teams'),
            Comment(
                avatar: 'logo_ceib.png',
                userName: 'null',
                content:
                    'A Dart template generator which helps teams generator which helps teams '),
          ],
          treeThemeData:
              TreeThemeData(lineColor: Colors.red[800]!, lineWidth: 3),
          avatarRoot: (context, data) => PreferredSize(
            preferredSize: Size.fromRadius(30),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('lib/assets/logo_ceib.png'),
              ),
            ),
          ),
          avatarChild: (context, data) => const PreferredSize(
            preferredSize: Size.fromRadius(20),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage('lib/assets/logo_ceib.png'),
            ),
          ),
          contentChild: (context, Comment data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'dangngocduc',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${data.content}',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          contentRoot: (context, Comment data) {
            return InkWell(
              onTap: () {
                //Open comment page and show comments
                //Navigator.of(context).pushNamed('/post-comments', arguments: postID);
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CircleAvatar(
                        //   radius: 30,
                        //   backgroundImage: CachedNetworkImageProvider(imgURL),
                        // ),
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
                                    Expanded(
                                      child: Text("fran",
                                          style:
                                              GoogleFonts.barlowSemiCondensed(
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "28/11/1998",
                                        style: GoogleFonts.hindMadurai(),
                                      ),
                                    ),
                                    // if (uid == _user?.uid)
                                    //   IconButton(
                                    //       constraints:
                                    //           const BoxConstraints(maxHeight: 25),
                                    //       onPressed: _confirmDelete,
                                    //       icon: const Icon(
                                    //         Icons.delete_outline_rounded,
                                    //       ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                MarkdownBody(
                                  data: avoidHeadings(data.content),
                                  styleSheet: MarkdownStyleSheet(
                                      p: GoogleFonts.hindMadurai(
                                          fontSize: 15.5),
                                      a: GoogleFonts.hindMadurai(
                                          fontSize: 15.5,
                                          color: Colors.red,
                                          decoration: TextDecoration.none)),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              buildSnackBar(
                                  context: context, text: "Todavía no anda"));
                        },
                        icon: const Icon(
                            CupertinoIcons.bubble_left_bubble_right_fill),
                        color: Colors.grey,
                      ),
                      Row(
                        children: [
                          Text("LIKE")
                          // LikeButtonForPosts(
                          //     postID: postID,
                          //     likesCount: likeCount ?? 0,
                          //     isLiked: isLiked),
                          // if (likeCount != 0 && likeCount != null)
                          //   Text(
                          //     '$likeCount',
                          //     style: TextStyle(color: Colors.grey[600]),
                          //   ),
                        ],
                      ),
                    ],
                  ),
                  Divider()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
