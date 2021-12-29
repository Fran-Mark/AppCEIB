import 'package:ceib/models/turno_bici.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Bicis extends ChangeNotifier {
  final _bikes = FirebaseFirestore.instance.collection('bikes');

  Future<String> requestBike(BiciRequest request) async {
    final _bikeNumber = request.bikeNumber;
    try {
      final _isAvailable = await _checkAvailability(_bikeNumber);
      if (_isAvailable == null) return "Hay un problema de conexión";
      if (_isAvailable) {
        await _updateBikeInfo(
            id: '',
            bikeNumber: _bikeNumber,
            holder: request.username,
            email: request.userEmail,
            isAvailable: false,
            isRequestApproved: false,
            startingDate: request.requestDate.toString());
        notifyListeners();
        return "Se envió la solicitud!";
      } else
        return "Bici no disponible";
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<String> approveRequest(int _bikeNumber) async {
    try {
      final bike = await _bikes.doc('$_bikeNumber').get();
      final _email = bike['email'] as String;
      final _username = bike['holder'] as String;
      final _requestDate = bike['started'] as String;

      final _info =
          await _bikes.doc("$_bikeNumber").collection('bookingHistory').add({
        "userEmail": _email,
        "userName": _username,
        "requestDate": _requestDate,
        "approvedDate": DateTime.now().toString(),
        "devolutionDate": "",
        "isRequestAproved": true,
        "wantsToReturn": false,
        "returnRequestDate": ""
      });
      await _bikes
          .doc('$_bikeNumber')
          .update({"requestID": _info.id, "isRequestApproved": true});
      await _bikes
          .doc("currentStatus")
          .collection("info")
          .doc('$_bikeNumber')
          .update({"isApproved": true});
      notifyListeners();
      return "Bici concedida!";
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<String> cancelRequest(int _bikeNumber) async {
    try {
      await _updateBikeInfo(
          bikeNumber: _bikeNumber,
          isAvailable: true,
          holder: '',
          email: '',
          id: '',
          isRequestApproved: false,
          startingDate: '');
      notifyListeners();
      return "Solicitud cancelada!";
    } on Exception {
      return "Algo salió mal";
    }
  }

  Future<String> requestReturn(int _bikeNumber) async {
    try {
      final bike = await _bikes.doc('$_bikeNumber').get();
      final _id = bike.data()!['requestID'] as String;

      await _bikes
          .doc('$_bikeNumber')
          .collection('bookingHistory')
          .doc(_id)
          .update({
        "wantsToReturn": true,
        "returnRequestDate": DateTime.now().toString()
      });

      notifyListeners();
      return "Solicitud registrada! Falta la confirmación del sec de deportes";
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<String> confirmReturn(int _bikeNumber) async {
    try {
      final bike = await _bikes.doc('$_bikeNumber').get();
      final _id = bike.data()!['requestID'] as String;
      await _bikes
          .doc('$_bikeNumber')
          .collection('bookingHistory')
          .doc(_id)
          .update({"devolutionDate": DateTime.now().toString()});
      await _updateBikeInfo(
          bikeNumber: _bikeNumber,
          isAvailable: true,
          holder: '',
          email: '',
          id: '',
          isRequestApproved: false,
          startingDate: '');
      notifyListeners();
      return "Devuelta!";
    } catch (e) {
      return "Algo salió mal";
    }
  }

  Future<void> _updateBikeInfo(
      {required int bikeNumber,
      required bool isAvailable,
      required String holder,
      required String email,
      required String startingDate,
      required String id,
      required bool isRequestApproved}) async {
    await _bikes.doc("$bikeNumber").update({
      "isAvailable": isAvailable,
      "holder": holder,
      "email": email,
      "started": startingDate,
      "requestID": id,
      "isRequestApproved": isRequestApproved
    });
    await _bikes
        .doc("currentStatus")
        .collection("info")
        .doc('$bikeNumber')
        .update({"holder": holder, "isApproved": isRequestApproved});
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getStatus() async {
    final _info = await _bikes.doc('currentStatus').collection('info').get();
    final _docs = _info.docs;
    final Future<List<Map<String, dynamic>>> _data = Future.value([]);
    for (final e in _docs) {
      final element = e.data();
      _data.then((value) => value.add(element));
    }
    notifyListeners();
    return _data;
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
}
