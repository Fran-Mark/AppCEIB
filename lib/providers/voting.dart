import 'package:ceib/models/vote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Voting with ChangeNotifier {
  final _votingCollection = FirebaseFirestore.instance.collection('voting');
  //castVote
  Future<String> castVote(Vote vote, String userID) async {
    try {
      await _votingCollection
          .doc('yaVotaron')
          .update({userID: 'Preconfirmado'});
      await _votingCollection.doc('votos').collection('data').add(
          {'presidente': vote.presidente, 'informatica': vote.secInfomatica});
      await _votingCollection.doc('yaVotaron').update({userID: 'Confirmado'});
      return "Voto Confirmado";
    } on Exception {
      return "Error";
    }
  }
  //getResults
}
