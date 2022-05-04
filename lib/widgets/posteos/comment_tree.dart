import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceib/extensions/datetime_extension.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/helpers/styles.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/posteos.dart';
import 'package:ceib/widgets/my_alert_dialog.dart';
import 'package:ceib/widgets/posteos/like_for_posts.dart';
import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CommentTreeForPosts extends StatelessWidget {
  const CommentTreeForPosts(
      {Key? key,
      required this.imgURL,
      required this.displayName,
      required this.postID,
      required this.uid,
      required this.data,
      required this.date,
      required this.likeCount,
      required this.isLiked,
      required this.comments})
      : super(key: key);
  final String imgURL;
  final String displayName;
  final String postID;
  final String uid;
  final String? data;
  final DateTime date;
  final int? likeCount;
  final bool isLiked;
  final List<dynamic>? comments;

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

    Future<void> _addComment(String comment) async {
      final _result = await _posteos.addComment(postID, _user!.uid, comment);

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(buildSnackBar(context: context, text: _result));
      // Navigator.of(context).pop();
    }

    return CommentTreeWidget(
      Comment(avatar: 'null', content: data, userName: displayName),
      comments!,
      avatarRoot: (context, value) => PreferredSize(
        preferredSize: const Size.fromRadius(30),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: CachedNetworkImageProvider(imgURL),
        ),
      ),
      avatarChild: (context, data) {
        final _mapa = data as Map<String, dynamic>?;
        final _commentImgURL = checkImageURL(_mapa?['imgURL'] as String?);
        return PreferredSize(
          preferredSize: const Size.fromRadius(25),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(_commentImgURL),
          ),
        );
      },
      contentRoot: (context, value) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(displayName,
                                  style: displayNameInPostStyle),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                date.formatDate(),
                                style: GoogleFonts.hindMadurai(),
                              ),
                            ),
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
                          styleSheet: MarkdownStyleSheet(
                              p: GoogleFonts.hindMadurai(fontSize: 15.5),
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
                onPressed: () async {
                  //TODO: add comment
                  _addComment("Hola");
                },
                icon: const Icon(CupertinoIcons.bubble_left_bubble_right,
                    color: Colors.grey),
              ),
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
              ),
            ],
          ),
        ],
      ),
      contentChild: (context, data) {
        final _mapa = data as Map<String, dynamic>?;
        final _name = _mapa?['displayName'] as String? ?? "ERROR";
        final _text = _mapa?['comment'] as String? ?? "ERROR";
        final _timeStamp = DateTime.tryParse(_mapa?['timeStamp'] as String);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,

                      //  mainAxisAlignment:                                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _name,
                          style: displayNameInPostStyle,
                        ),
                        if (_timeStamp != null)
                          Text(
                            _timeStamp.formatDate(),
                            style: GoogleFonts.hindMadurai(),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  MarkdownBody(
                    data: avoidHeadings(_text),
                    styleSheet: MarkdownStyleSheet(
                        p: GoogleFonts.hindMadurai(fontSize: 15.5),
                        a: GoogleFonts.hindMadurai(
                            fontSize: 15.5,
                            color: Colors.red,
                            decoration: TextDecoration.none)),
                  ),
                ],
              ),
            ),
          ]),
        );
      },
      treeThemeData:
          const TreeThemeData(lineColor: Color.fromARGB(255, 170, 69, 69)),
    );
  }
}
