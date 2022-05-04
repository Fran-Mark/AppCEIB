import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/posteos.dart';
import 'package:ceib/screens/initial_tabs/main_screen.dart';
import 'package:ceib/screens/new_post.dart';
import 'package:ceib/widgets/posteos/posteo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _posteos = Provider.of<Posteos>(context).posteos();
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    return Stack(
      fit: StackFit.expand,
      children: [
        StreamBuilder(
            stream: _posteos,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              final _posts = snapshot.data!.docs;
              final _length = _posts.length;
              if (_length == 0) {
                return Center(
                  child: Text(
                    "Nada por aquí",
                    style: GoogleFonts.hindMadurai(fontSize: 30),
                  ),
                );
              }
              return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  itemCount: _length,
                  itemBuilder: (context, index) {
                    final _postData =
                        _posts[index].data() as Map<String, dynamic>?;
                    if (_postData == null) {
                      return Center(
                        child: Column(
                          children: [
                            const Text("Algo salió mal"),
                            TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(MainScreen.routeName),
                              child: const Text("Volver"),
                            )
                          ],
                        ),
                      );
                    }

                    final uid = _user?.uid;
                    final _likeList = _postData['likedBy'] as List<dynamic>?;

                    final _comments = _postData['comments'] as List<dynamic>?;

                    final _isLiked = _likeList?.contains(uid) ?? false;
                    return Posteo(
                      postID: _posts[index].id,
                      data: _postData['data'] as String?,
                      date: DateTime.tryParse(_postData['date'] as String),
                      uid: _postData['uid'] as String,
                      likeCount: _postData['likesCount'] as int?,
                      isLiked: _isLiked,
                      comments: _comments,
                    );
                  });
            }),
        Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
                tooltip: "Postea algo",
                child: const Icon(CupertinoIcons.bubble_right_fill),
                onPressed: () {
                  Navigator.of(context).pushNamed(NewPostScreen.routeName);
                })),
      ],
    );
  }
}
