import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuthentication {
  static Future<User?> checkAuth() async {
    User? login;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint("belum login");
        login = user;
      } else {
        login = user;
      }
    });
    return login;
  }
}
