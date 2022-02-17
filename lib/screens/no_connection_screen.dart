import 'dart:async';
import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/widgets/loading_ceib.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../providers/connectivity.dart';

class NoConnectionWidget extends StatefulWidget {
  const NoConnectionWidget({Key? key}) : super(key: key);

  @override
  State<NoConnectionWidget> createState() => _NoConnectionWidgetState();
}

class _NoConnectionWidgetState extends State<NoConnectionWidget> {
  bool _isLoading = false;
  late StreamSubscription<dynamic> _connectionStream;
  bool _hasConnection = ConnectionStatusSingleton.getInstance().hasConnection;
  @override
  void initState() {
    _connectionStream = ConnectionStatusSingleton.getInstance()
        .connectionChange
        .listen((event) {
      _hasConnection = event as bool;
      if (_hasConnection) main();
    });
    super.initState();
  }

  @override
  void dispose() {
    _connectionStream.cancel();
    super.dispose();
  }

  void _toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.red,
          textTheme: TextTheme(
            button: GoogleFonts.raleway(fontWeight: FontWeight.bold),
          )),
      home: Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoadingCEIB(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Esperando conexión",
                style: GoogleFonts.hindMadurai(fontSize: 22),
              ),
            ),
            if (!_isLoading)
              TextButton(
                  onPressed: () async {
                    _toggleIsLoading();
                    await main().then((value) => _toggleIsLoading());
                  },
                  child: Text(
                    "Intentar de vuelta",
                    style: GoogleFonts.hindMadurai(fontSize: 15),
                  )),
            if (_isLoading) const CircularProgressIndicator.adaptive()
          ],
        ),
      ),
    );
  }
}
