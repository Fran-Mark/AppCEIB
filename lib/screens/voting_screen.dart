import 'package:ceib/helpers/helper_functions.dart';
import 'package:ceib/models/vote.dart';
import 'package:ceib/providers/voting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VotingScreen extends StatelessWidget {
  const VotingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _votingProvider = Provider.of<Voting>(context);
    final _user = Provider.of<User>(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Center(
        child: TextButton(
          child: Text("Vota a x"),
          onPressed: () async {
            final _vote = await _votingProvider.castVote(
                Vote(
                    presidente: "Alguien",
                    secInfomatica: "francisco.marquinez@ib.edu.ar",
                    timestamp: DateTime.now().toString()),
                _user.uid);
            ScaffoldMessenger.of(context)
                .showSnackBar(buildSnackBar(context: context, text: _vote));
          },
        ),
      ),
    );
  }
}
