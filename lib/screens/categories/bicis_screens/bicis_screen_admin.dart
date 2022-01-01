import 'dart:async';

import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/models/turno_bici.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/bicis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../extensions/user_extension.dart';

class BicisAdminScreen extends StatelessWidget {
  const BicisAdminScreen({Key? key}) : super(key: key);
  static const routeName = '/bicis-admin-screen';

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
      final _requestData = await _bikeBookingsCollection.requestBike(_request);
      if (_requestData == "Se envió la solicitud!") {
        final _result =
            await _bikeBookingsCollection.approveRequest(_bikeNumber);
        ScaffoldMessenger.of(context)
            .showSnackBar(buildSnackBar(context: context, text: _result));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            buildSnackBar(context: context, text: "No hay conexión"));
      }
    }

    Future<void> _returnBike(int _bikeNumber) async {
      await _bikeBookingsCollection.requestReturn(_bikeNumber);
      final _result = await _bikeBookingsCollection.confirmReturn(_bikeNumber);

      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: _result));
    }

    Future<void> _confirmReturn(int _bikeNumber) async {
      final _result = await _bikeBookingsCollection.confirmReturn(_bikeNumber);
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

    Future<void> _denyRequest(int _bikeNumber) async {
      final _result = await _bikeBookingsCollection.cancelRequest(_bikeNumber);
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: _result));
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
                          final _status =
                              snapshot.data as List<Map<String, dynamic>>?;
                          if (_status == null) {
                            return const Icon(Icons.error);
                          }
                          final _holders =
                              _status.map((e) => e['holder']).toList();
                          final _requestsStatus = _status
                              .map((e) => e['isApproved'] as bool)
                              .toList();

                          if (_holders[index] == _user.displayName) {
                            final _bikeNumber = index + 1;
                            if (_requestsStatus[index]) {
                              return TextButton(
                                  onPressed: () {
                                    _returnBike(_bikeNumber);
                                  },
                                  child: const Text("Ya la devolví!"));
                            } else {
                              return const Text(
                                  "La solicitud debería autoaprobarse");
                            }
                          } else if (_holders[index] == "")
                            return TextButton(
                                onPressed: () {
                                  final _bikeNumber = index + 1;
                                  _bookBike(_bikeNumber);
                                },
                                child: const Text("Reservar!"));
                          else if (_requestsStatus[index]) {
                            return FittedBox(
                              child: Column(
                                children: [
                                  Text("Bici reservada por ${_holders[index]}"),
                                  TextButton(
                                      onPressed: () {
                                        final _bikeNumber = index + 1;
                                        _confirmReturn(_bikeNumber);
                                      },
                                      child: const Text("Ya la devolvió"))
                                ],
                              ),
                            );
                          } else {
                            return FittedBox(
                              child: Column(
                                children: [
                                  Text("Bici pedida por ${_holders[index]}"),
                                  Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            final _bikeNumber = index + 1;
                                            _approveRequest(_bikeNumber);
                                          },
                                          child: const Text("Aprobar")),
                                      TextButton(
                                          onPressed: () {
                                            final _bikeNumber = index + 1;
                                            _denyRequest(_bikeNumber);
                                          },
                                          child: const Text("Rechazar"))
                                    ],
                                  ),
                                ],
                              ),
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
