import 'package:ceib/models/turno_bici.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Bicis extends ChangeNotifier {
  final _bikes = FirebaseFirestore.instance.collection('bikes');

  Future<String> bookBike(BiciRequest request) async {
    final _bikeNumber = request.bikeNumber;
    try {
      final _isAvailable = await checkAvailability(_bikeNumber);
      if (_isAvailable == null) return "Hay un problema de conexión";
      if (_isAvailable) {
        await _bikes.doc("$_bikeNumber").collection('bookingHistory').add({
          "userEmail": request.userEmail,
          "userName": request.username,
          "requestDate": request.requestDate.toString(),
          "devolutionDate": ""
        });
        await _bikes.doc("$_bikeNumber").update({
          "isAvailable": false,
          "holder": request.username,
          "started": request.requestDate.toString()
        });
        notifyListeners();
        return "Se pidió la bici!";
      } else
        return "Bici no disponible";
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<String> returnBike(BiciRequest _request) async {
    try {
      return "";
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<String> getHolder(int _bikeNumber) async {
    try {
      final _bikeData = await _bikes.doc('$_bikeNumber').get();
      if (_bikeData.data() == null) return "Algo salió mal";
      final _holder = _bikeData.data()!['holder'];
      return _holder;
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<bool?> checkAvailability(int bikeNumber) async {
    try {
      final _bikeData = await _bikes.doc("$bikeNumber").get();
      if (_bikeData.data() == null) {
        return null;
      }
      final _isAvailable = _bikeData.data()!['isAvailable'];
      if (_isAvailable) {
        notifyListeners();
        return true;
      }
      notifyListeners();
      return false;
    } catch (e) {
      return null;
    }
  }
}
