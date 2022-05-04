import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/posteos.dart';
import 'package:ceib/providers/user_data.dart';
import 'package:ceib/widgets/posteos/posteo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);
  static const routeName = '/new-post';
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _form = GlobalKey<FormState>();
  final _data = TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    _data.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _userImg = Provider.of<UserData>(context).imageURL ??
        'https://static.planetminecraft.com/files/resource_media/screenshot/1244/steve_4048323.jpg';

    final _posteos = Provider.of<Posteos>(context);

    Future<void> _uploadPost() async {
      final isValid = _form.currentState?.validate();
      if (!isValid!) {
        return;
      }
      _form.currentState?.save();
      final _posteo = Posteo(
          data: _data.text,
          date: DateTime.now(),
          likeCount: 0,
          isLiked: false,
          comments: List.empty(),
          uid: _user!.uid,
          postID: '');
      final _result = await _posteos.uploadPost(_posteo);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: _result));
    }

    return Scaffold(
      appBar: AppBar(
          title: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(_userImg),
          ),
          centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Form(
              key: _form,
              child: TextFormField(
                controller: _data,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    counterText: "Seguro tenés algo muy interesante para decir",
                    alignLabelWithHint: true,
                    //floatingLabelAlignment: FloatingLabelAlignment.center,
                    hintText: "Escribí algo...",
                    label: const Text("Nuevo Posteo"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(width: 3))),
                expands: true,
                maxLines: null,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                validator: (data) {
                  if (data!.isEmpty) {
                    return 'Ingresa algo';
                  }
                  return null;
                },
                onSaved: (data) {
                  if (data != null) _data.text = data;
                },
              ),
            ),
            Positioned(
                right: 25,
                bottom: 40,
                child: ElevatedButton(
                  onPressed: _uploadPost,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)))),
                  child: const Text("Publicar"),
                ))
          ],
        ),
      ),
    );
  }
}
