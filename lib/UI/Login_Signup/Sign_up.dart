import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:pratik_app/UI/HomePage/HomePage.dart';
import 'package:pratik_app/UI/Login_Signup/Login.dart';
import 'package:pratik_app/UI/Profile_Page/Create_Profile_page.dart';
import 'package:pratik_app/UI/Widget/RoundButton.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _Signup();
}

class _Signup extends State<SignUp> {
  final ref = FirebaseFirestore.instance.collection("profiles");
  bool loading = false;
  final _form = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
            "SignUp page",
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
                  image: AssetImage("assets/back.png"), fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up",
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
                    buttonname: "Sign up",
                    tap: () {
                      if (_form.currentState!.validate()) {
                        _auth
                            .createUserWithEmailAndPassword(
                                email: _emailController.text.toString(),
                                password: _PasswordController.text.toString())
                            .then((value) {
                          ref.doc(_emailController.text.toString()).set({
                            "email": _emailController.text.toString(),
                            "name": "",
                            "profilePic": "",
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => ProfilePage()),
                              (route) => false);
                        }).onError((error, StackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Container(child: Text(error.toString()))));
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
                          MaterialPageRoute(builder: (_) => const Login()));
                    },
                    child: const Text.rich(TextSpan(
                        text: "Do you have accout ? ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 8, 0, 17),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        children: [
                          TextSpan(
                              text: "Sign in",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 8, 0, 17),
                                  fontWeight: FontWeight.bold))
                        ])),
                  )
                ],
              ),
            ),
          ),
        )));
  }
}
