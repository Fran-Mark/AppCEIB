import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/models/turno_bici.dart';
import 'package:ceib/providers/auth_service.dart';
import 'package:ceib/providers/bicis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
        appBar: buildAppBar(),
        body: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                child: ListTile(
                    leading: Text("Bici ${index + 1}"),
                    trailing: FutureBuilder(
                      future: _bikeBookingsCollection.getHolder(index + 1),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final _holder = snapshot.data as String;
                          if (_holder == "")
                            return TextButton(
                                onPressed: () {
                                  final _bikeNumber = index + 1;
                                  _bookBike(_bikeNumber);
                                },
                                child: Text("Reservar!"));
                          else if (_holder == _user.displayName) {
                            return TextButton(
                                onPressed: () {},
                                child: Text("Ya la devolví!"));
                          } else {
                            return Text(
                              "Reservada :(",
                              style: TextStyle(color: Colors.grey),
                            );
                          }
                        } else
                          return CircularProgressIndicator.adaptive();
                      },
                    )),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black)),
              );
            }));
  }
}
