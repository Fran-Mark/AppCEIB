import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/storage.dart';
import 'package:ceib/widgets/my_alert_dialog.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _storage = Provider.of<Storage>(context);

    Future<void> _selectImage() async {
      if (kIsWeb) return;
      final _pick = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 60);
      if (_pick == null) return;

      final _img = File(_pick.path);

      final _result =
          await _storage.uploadImage(_img, '/profile-pictures/${_user!.email}');
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
    }

    return FutureBuilder(
        future: _storage.getUserImageURL(_user!.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return const CircularProgressIndicator.adaptive();

          if (snapshot.hasData) {
            final _imgURL = snapshot.data as String?;

            return InkWell(
                onTap: _selectImage,
                onLongPress: _confirmDelete,
                child: CircleAvatar(
                    backgroundColor: Colors.grey[350],
                    radius: 70,
                    backgroundImage: CachedNetworkImageProvider(_imgURL!)));
          } else {
            return InkWell(
              onTap: _selectImage,
              child: CircleAvatar(
                radius: 50,
                child: Image.asset('lib/assets/steve.png'),
              ),
            );
          }
        });
  }
}
