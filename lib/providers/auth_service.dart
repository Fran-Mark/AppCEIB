import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../extensions/string_extension.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> reloadData(User user) async {
    isLoading = true;
    try {
      await user.reload();
      isLoading = false;
    } catch (e) {
      //TODO: Dar algún feedback
    }
    notifyListeners();
  }

  Future<User?> register(String email, String password) async {
    isLoading = true;
    try {
      final UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = authResult.user;

      if (user != null) {
        await user.sendEmailVerification();
        final displayName = createDisplayName(user);
        await user.updateDisplayName(displayName);
      }
      isLoading = false;

      return user;
    } on SocketException {
      isLoading = false;
      errorMessage =
          "No tenés conexión a internet :'(. Entrá a login.cnea.gob.ar:4100";
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      errorMessage = translateMessage(e);
    } catch (e) {
      errorMessage = 'Algo salió mal';
    }
    notifyListeners();
  }

  Future<User?> login(String email, String password) async {
    isLoading = true;
    try {
      final UserCredential authResult = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = authResult.user;
      isLoading = false;

      if (user != null && user.emailVerified) {
        return user;
      } else {
        errorMessage = 'El usuario no está verificado';
      }
      return null;
    } on SocketException {
      isLoading = false;
      errorMessage =
          "No tenés conexión a internet :'(. Entrá a login.cnea.gob.ar:4100";
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      errorMessage = translateMessage(e);
    } catch (e) {
      errorMessage = 'Algo salió mal';
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
    notifyListeners();
  }

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  set errorMessage(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  Future<String?> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      errorMessage = '';
      return 'Se envió el correo de reestablecimiento';
    } on FirebaseAuthException catch (e) {
      errorMessage = translateMessage(e);
      return null;
    } catch (e) {
      errorMessage = 'No se pudo enviar el mail';
      return null;
    }
  }

  Stream<User> get user => firebaseAuth.authStateChanges().map((event) {
        return event!;
      });
}

String translateMessage(FirebaseAuthException e) {
  String msg;
  switch (e.code) {
    case 'invalid-email':
      msg = 'Email inválido';
      break;
    case 'wrong-password':
      msg = 'Contraseña incorrecta';
      break;

    case 'user-not-found':
      msg = 'El mail no está registrado';
      break;
    case 'weak-password':
      msg = 'La contraseña es muy débil';
      break;
    case 'operation-not-allowed':
      msg = 'Operación no permitida';
      break;
    case 'email-already-in-use':
      msg = 'El email ya está en uso';
      break;
    default:
      msg = 'Algo salió mal';
  }
  return msg;
}

String createDisplayName(User user) {
  final String email = user.email!;
  final splitAtDot = email.split('@')[0].split('.');
  final firstName = splitAtDot[0].capitalizeFirst();
  final lastName = splitAtDot[1].capitalizeFirst();
  final displayName = '$firstName $lastName';

  return displayName;
}
