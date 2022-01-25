import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/storage.dart';
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
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _storage = Provider.of<Storage>(context);
    final _userData = Provider.of<UserData>(context);
    final _imgURL = _userData.imageURL;

    Future<void> _selectImage() async {
      if (kIsWeb) return;
      final _pick = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 60);
      if (_pick == null) return;

      final _img = File(_pick.path);
      _toggleIsUploading();
      final _result =
          await _storage.uploadImage(_img, '/profile-pictures/${_user!.email}');
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
                  final _res =
                      await _storage.deleteProfilePicture(_user!.email!);
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
    if (_imgURL != null) {
      return InkWell(
          onTap: _selectImage,
          onLongPress: _confirmDelete,
          child: CircleAvatar(
              backgroundColor: Colors.grey[350],
              radius: 70,
              backgroundImage: CachedNetworkImageProvider(_imgURL)));
    } else {
      return InkWell(
        onTap: _selectImage,
        child: CircleAvatar(
          radius: 50,
          child: Image.asset('lib/assets/steve.png'),
        ),
      );
    }
  }
}
