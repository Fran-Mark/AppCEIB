import 'package:ceib/providers/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_like/many_like.dart';
import 'package:provider/provider.dart';

import '../providers/posteos.dart';

class LikeButtonForPosts extends StatefulWidget {
  const LikeButtonForPosts(
      {Key? key,
      required this.postID,
      required this.likesCount,
      required this.isLiked})
      : super(key: key);
  final String postID;
  final int likesCount;
  final bool isLiked;
  @override
  State<LikeButtonForPosts> createState() => _LikeButtonForPostsState();
}

class _LikeButtonForPostsState extends State<LikeButtonForPosts> {
  late IconData _icon;
  late Color _color;
  late Duration duration;
  late bool isLiked;
  void setIcons() {
    setState(() {
      if (isLiked) {
        _icon = CupertinoIcons.heart_fill;
        _color = Colors.red;
        duration = const Duration(seconds: 1);
      } else {
        _icon = CupertinoIcons.heart;
        _color = Colors.grey;
        duration = Duration.zero;
      }
    });
  }

  @override
  void initState() {
    isLiked = widget.isLiked;
    setIcons();
    super.initState();
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      setIcons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _posteos = Provider.of<Posteos>(context);
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;

    Future<void> _toggleLike() async {
      toggleLike();
      if (isLiked)
        await _posteos.addLike(widget.postID, _user!.uid);
      else
        await _posteos.removeLike(widget.postID, _user!.uid);
    }

    return ManyLikeButton(
      onTap: (int count) {
        _toggleLike();
        return;
      },
      duration: duration,
      tapDelay: Duration.zero,
      tapCallbackOnlyOnce: false,
      tickCount: widget.likesCount,
      child: Icon(
        _icon,
        color: _color,
      ),
    );
  }
}
