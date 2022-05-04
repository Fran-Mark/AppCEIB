import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceib/helpers/helper_functions.dart';

import 'package:ceib/providers/user_data.dart';
import 'package:ceib/widgets/my_alert_dialog.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool _isUploading = false;
  void _toggleIsUploading() {
    setState(() {
      _isUploading = !_isUploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    final _imgURL = _userData.imageURL;

    Future<void> _selectImage() async {
      if (kIsWeb) return;
      final _pick = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 60);
      if (_pick == null) return;

      final _img = File(_pick.path);
      _toggleIsUploading();
      final _result = await _userData.uploadImg(_img);
      _toggleIsUploading();
      await _userData.refreshImageURL();
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: _result));
    }

    Future<void> _confirmDelete() async {
      if (kIsWeb) return;
      showDialog(
          context: context,
          builder: (context) {
            return MyAlertDialog(
                title: "Borrar foto",
                content: "Seguro que querés eliminar la foto de perfil?",
                handler: () async {
                  final _res = await _userData.deleteImg();
                  ScaffoldMessenger.of(context).showSnackBar(
                      buildSnackBar(context: context, text: _res));
                  Navigator.pop(context, 'Si');
                });
          });
      await _userData.refreshImageURL();
    }

    if (_isUploading) {
      return const CircularProgressIndicator.adaptive();
    }

    String _link;
    if (_imgURL != null) {
      _link = _imgURL;
    } else {
      _link =
          'https://firebasestorage.googleapis.com/v0/b/app-del-ceib.appspot.com/o/profile-pictures%2Fdefault.jpeg?alt=media&token=eb6455da-d4eb-4c92-beca-9c2f070d7dfb';
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        InkWell(
            onLongPress: _imgURL != null ? _confirmDelete : null,
            child: CircleAvatar(
                backgroundColor: Colors.grey[350],
                radius: 70,
                backgroundImage: CachedNetworkImageProvider(_link))),
        if (!kIsWeb)
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: const Color.fromRGBO(255, 230, 234, 1))),
              child: IconButton(
                onPressed: _selectImage,
                icon: const Icon(
                  Icons.edit,
                  size: 23,
                ),
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
