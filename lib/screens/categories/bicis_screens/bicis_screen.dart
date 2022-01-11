import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/models/turno_bici.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/bicis.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BicisScreen extends StatelessWidget {
  const BicisScreen({Key? key}) : super(key: key);
  static const routeName = '/bicis-screen';

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AuthServices>(context).firebaseAuth.currentUser!;
    final _bikeBookingsCollection = Provider.of<Bicis>(context);

    Future<void> _requestBike(int _bikeNumber) async {
      final _request = BiciRequest(
          userEmail: _user.email!,
          username: _user.displayName!,
          bikeNumber: _bikeNumber,
          requestDate: DateTime.now());
      final _result = await _bikeBookingsCollection.requestBike(_request);
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: _result));
    }

    Future<void> _requestReturn(int _bikeNumber) async {
      final _result = await _bikeBookingsCollection.requestReturn(_bikeNumber);

      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: _result));
    }

    Future<void> _cancelRequest(int _bikeNumber) async {
      final _result = await _bikeBookingsCollection.cancelRequest(_bikeNumber);
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context: context, text: _result));
    }

    return Scaffold(
        appBar: buildAppBar(),
        body: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: GridTile(
                    child: Column(
                  children: [
                    Expanded(
                        child: Center(
                            child: Text(
                      "Bici ${index + 1}",
                      style: GoogleFonts.hindMadurai(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ))),
                    const Divider(
                      thickness: 1.5,
                    ),
                    FutureBuilder(
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

                          final _isHolder =
                              _holders.contains(_user.displayName);
                          if (_holders[index] == _user.displayName) {
                            final _bikeNumber = index + 1;
                            if (_requestsStatus[index]) {
                              return TextButton(
                                  onPressed: () {
                                    _requestReturn(_bikeNumber);
                                  },
                                  child: const Text("Iniciar devolución!"));
                            } else {
                              return FittedBox(
                                child: Column(
                                  children: [
                                    const Text("Esperando aprobación"),
                                    TextButton(
                                        onPressed: () {
                                          _cancelRequest(_bikeNumber);
                                        },
                                        child: const Text("Cancelar"))
                                  ],
                                ),
                              );
                            }
                          } else if (_isHolder) {
                            return const Text(
                              "Ya pediste una bici",
                              style: TextStyle(color: Colors.grey),
                            );
                          } else if (_holders[index] == "")
                            return TextButton(
                                onPressed: () {
                                  final _bikeNumber = index + 1;
                                  _requestBike(_bikeNumber);
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
                    ),
                  ],
                )),
              );
            }));
  }
}
