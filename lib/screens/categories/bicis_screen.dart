import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/models/turno_bici.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/bicis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../extensions/user_extension.dart';

class BicisScreen extends StatelessWidget {
  const BicisScreen({Key? key}) : super(key: key);
  static const routeName = '/bicis-screen';

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser!;
    final _bikeBookingsCollection = Provider.of<Bicis>(context);

    Future<void> _bookBike(int _bikeNumber) async {
      final _request = BiciRequest(
          userEmail: _user.email!,
          username: _user.displayName!,
          bikeNumber: _bikeNumber,
          requestDate: DateTime.now());
      final _result = await _bikeBookingsCollection.bookBike(_request);
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: _result));
    }

    Future<void> _returnBike(int _bikeNumber) async {
      final _result = await _bikeBookingsCollection.returnBike(_bikeNumber);

      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: _result));
    }

    Future<void> _approveRequest(int _bikeNumber) async {
      final _hasPermissions = await _user.isSportsEditor();
      if (_hasPermissions) {
        final _result =
            await _bikeBookingsCollection.approveRequest(_bikeNumber);
        ScaffoldMessenger.of(context)
            .showSnackBar(buildSnackBar(context: context, text: _result));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            buildSnackBar(context: context, text: "No tenes permisos"));
      }
    }

    return Scaffold(
        appBar: buildAppBar(),
        body: ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 2)),
                child: ListTile(
                    leading: Text("Bici ${index + 1}"),
                    trailing: FutureBuilder(
                      future: _bikeBookingsCollection.getStatus(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final _holdersDoc = snapshot.data
                              as DocumentSnapshot<Map<String, dynamic>>?;
                          if (_holdersDoc == null ||
                              _holdersDoc.data() == null) {
                            return const Icon(Icons.error);
                          }
                          final _holder = _holdersDoc.data()!;
                          final _isHolder =
                              _holder.containsValue(_user.displayName);
                          if (_holder['${index + 1}'] == _user.displayName) {
                            return TextButton(
                                onPressed: () {
                                  final _bikeNumber = index + 1;
                                  _returnBike(_bikeNumber);
                                },
                                child: const Text("Ya la devolví!"));
                          } else if (_isHolder) {
                            return const Text(
                              "Ya pediste una bici",
                              style: TextStyle(color: Colors.grey),
                            );
                          } else if (_holder['${index + 1}'] == "")
                            return TextButton(
                                onPressed: () {
                                  final _bikeNumber = index + 1;
                                  _bookBike(_bikeNumber);
                                },
                                child: const Text("Reservar!"));
                          else {
                            return const Text(
                              "Reservada :(",
                              style: TextStyle(color: Colors.grey),
                            );
                          }
                        } else
                          return const CircularProgressIndicator.adaptive();
                      },
                    )),
              );
            }));
  }
}
