import 'package:ceib/models/turno_bici.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Bicis extends ChangeNotifier {
  final _bikes = FirebaseFirestore.instance.collection('bikes');

  final _numberOfBikes = 6;

  Future<String> bookBike(BiciRequest request) async {
    final _bikeNumber = request.bikeNumber;
    try {
      final _isAvailable = await _checkAvailability(_bikeNumber);
      if (_isAvailable == null) return "Hay un problema de conexión";
      if (_isAvailable) {
        final _request =
            await _bikes.doc("$_bikeNumber").collection('bookingHistory').add({
          "userEmail": request.userEmail,
          "userName": request.username,
          "requestDate": request.requestDate.toString(),
          "devolutionDate": "",
          "isRequestAproved": false
        });
        final _id = _request.id;
        await _updateBikeInfo(_bikeNumber, false, request.username,
            request.requestDate.toString(), _id);
        notifyListeners();
        return "Se envió la solicitud!";
      } else
        return "Bici no disponible";
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<String> returnBike(int _bikeNumber) async {
    try {
      final bike = await _bikes.doc('$_bikeNumber').get();
      final _id = bike.data()!['requestID'] as String;
      final _requestDate = DateTime.parse(bike.data()!['started'] as String);
      final _devolutionDate = DateTime.now();
      final _minutesElapsed =
          _devolutionDate.difference(_requestDate).inMinutes;
      //Requests de menos de 10 minutos de duración se borran
      if (_minutesElapsed > 10) {
        await _bikes
            .doc('$_bikeNumber')
            .collection('bookingHistory')
            .doc(_id)
            .update({"devolutionDate": _devolutionDate.toString()});
      } else {
        await _bikes
            .doc('$_bikeNumber')
            .collection('bookingHistory')
            .doc(_id)
            .delete();
      }

      await _updateBikeInfo(_bikeNumber, true, '', '', '');
      notifyListeners();
      return "Devuelta!";
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<void> _updateBikeInfo(int _bikeNumber, bool isAvailable, String holder,
      String startingDate, String id) async {
    await _bikes.doc("$_bikeNumber").update({
      "isAvailable": isAvailable,
      "holder": holder,
      "started": startingDate,
      "requestID": id
    });
    await _bikes.doc("currentHolders").update({"$_bikeNumber": holder});
    notifyListeners();
  }

  Future<String> _getHolder(int _bikeNumber) async {
    try {
      final _bikeData = await _bikes.doc('$_bikeNumber').get();
      if (_bikeData.data() == null) return "Algo salió mal";
      final _holder = _bikeData.data()!['holder'] as String?;
      return _holder ?? '';
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<DocumentSnapshot> getAllHolders() async {
    final _holders = await _bikes.doc("currentHolders").get();
    notifyListeners();
    return _holders;
  }

  Future<int?> getBikeByHolder(String username) async {
    for (int i = 0; i < _numberOfBikes; i++) {
      final _holder = await _getHolder(i);
      if (_holder == username) return i + 1;
    }
    return null;
  }

  Future<bool?> _checkAvailability(int bikeNumber) async {
    try {
      final _bikeData = await _bikes.doc("$bikeNumber").get();
      if (_bikeData.data() == null) {
        return null;
      }
      final _isAvailable = _bikeData.data()!['isAvailable'] as bool;
      if (_isAvailable) {
        return true;
      }

      return false;
    } catch (e) {
      return null;
    }
  }

  // Future<bool?> isHolder(String username) async {
  //   try {
  //     final _query = await _bikes.where('holder', isEqualTo: username).get();
  //     if (_query.size == 0) return false;
  //     return true;
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
