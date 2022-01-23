import 'dart:io';

import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser;
    final _storage = Provider.of<Storage>(context);

    Future<void> _selectImage() async {
      final _img = await FilePicker.platform.pickFiles(type: FileType.image);
      if (_img != null) {
        final _path = _img.files.single.path;
        final _file = File(_path!);
        final _result = await _storage.uploadImage(
            _file, '/profile-pictures/${_user!.email}');
        ScaffoldMessenger.of(context)
            .showSnackBar(buildSnackBar(context: context, text: _result));
      }
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
                child: CircleAvatar(
                    backgroundColor: Colors.grey[350],
                    radius: 70,
                    backgroundImage: NetworkImage(_imgURL!)));
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
