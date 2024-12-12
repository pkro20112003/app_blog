// import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pratik_app/UI/MainPages/HomePage.dart';
import 'package:pratik_app/UI/Login_Signup/Sign_up.dart';
// import 'package:pratik_app/UI/Login_Signup/Sign_up.dart';

import 'package:pratik_app/UI/Widget/RoundButton.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => LoginPage();
}

class LoginPage extends State<Login> {
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _PasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 186, 229, 136),
        title: const Text(
          "Login Page",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/back.png"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.black),
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "enter email";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _PasswordController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: "6 digit pin",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "enter password";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundButton(
                  buttonname: "Login",
                  tap: () {
                    if (_form.currentState!.validate()) {
                      _auth
                          .signInWithEmailAndPassword(
                              email: _emailController.text.toString(),
                              password: _PasswordController.text.toString())
                          .then((value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => HomePage()),
                            (route) => false);
                      }).onError((error, StackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Container(child: Text(error.toString()))));
                      });
                    }
                  },
                  loading: loading,
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SignUp()));
                  },
                  child: const Text.rich(TextSpan(
                      text: "Don't have accout ? ",
                      style: TextStyle(
                          color: Color.fromARGB(255, 8, 0, 17),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text: "Register",
                            style: TextStyle(
                                color: Color.fromARGB(255, 8, 0, 17),
                                fontWeight: FontWeight.bold))
                      ])),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
