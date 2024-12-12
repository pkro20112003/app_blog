import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:pratik_app/UI/HomePage/HomePage.dart';
import 'package:pratik_app/UI/Login_Signup/Login.dart';

class SplashService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  void SplashTimer(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => Login()), (route) => false));
  }
}
