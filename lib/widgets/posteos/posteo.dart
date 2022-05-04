import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceib/extensions/datetime_extension.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/helpers/styles.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/posteos.dart';
import 'package:ceib/widgets/posteos/comment_tree.dart';
import 'package:ceib/widgets/posteos/like_for_posts.dart';
import 'package:ceib/widgets/my_alert_dialog.dart';
import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

// ignore: must_be_immutable
class Posteo extends StatefulWidget {
  Posteo(
      {Key? key,
      required this.data,
      required this.date,
      required this.likeCount,
      required this.isLiked,
      required this.comments,
      required this.uid,
      required this.postID})
      : super(key: key);
  final String postID;
  final String? data;
  final DateTime? date;
  final String uid;
  final List<dynamic>? comments;

  final bool isLiked;
  final int? likeCount;
  Future<void>? updateCachedData;

  @override
  State<Posteo> createState() => _PosteoState();
}

class _PosteoState extends State<Posteo> {
  @override
  void didChangeDependencies() {
    widget.updateCachedData = Provider.of<Posteos>(context).updateCachedData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _posteos = Provider.of<Posteos>(context);
    final _usersInfo = _posteos.cachedPosts;

    final _imgURL = checkImageURL(_usersInfo?[widget.postID]?['imgURL']);

    final _displayName = _usersInfo?[widget.postID]?['displayName'] ?? "nulo";
    return FutureBuilder(
        future: widget.updateCachedData,
        builder: (context, snapshot) {
          if (_usersInfo == null) {
            return SkeletonLoader(
                builder: PostLayout(
              data: widget.data,
              displayName: _displayName,
              imgURL: _imgURL,
              date: widget.date!,
              isLiked: widget.isLiked,
              likeCount: widget.likeCount,
              comments: widget.comments,
              postID: widget.postID,
              uid: widget.uid,
            ));
          }

          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
            child: PostLayout(
                data: widget.data,
                displayName: _displayName,
                imgURL: _imgURL,
                date: widget.date!,
                isLiked: widget.isLiked,
                likeCount: widget.likeCount,
                comments: widget.comments,
                postID: widget.postID,
                uid: widget.uid),
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

    if (comments != null) {
      if (comments!.isNotEmpty) {
        return InkWell(
          onTap: () {},
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: CommentTreeForPosts(
                uid: uid,
                postID: postID,
                comments: comments,
                date: date,
                displayName: displayName,
                imgURL: imgURL,
                isLiked: isLiked,
                likeCount: likeCount,
                data: data,
              ),
            ),
          ),
        );
      }
    }

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      buildSnackBar(context: context, text: "Todavía no anda"));
                },
                icon: const Icon(CupertinoIcons.bubble_left_bubble_right_fill),
                color: Colors.grey,
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
    );
  }
}
