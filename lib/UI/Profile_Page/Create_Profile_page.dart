import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pratik_app/UI/MainPages/HomePage.dart';
import 'package:pratik_app/UI/Widget/RoundButton.dart';
import 'package:pratik_app/Upload_image/UploadPicture.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final _form = GlobalKey<FormState>();
  String isUpload = "";
  final _picker = ImagePicker();
  final auth = FirebaseAuth.instance.currentUser!;
  final ref = FirebaseFirestore.instance.collection("profiles");
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: h,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/back2.png"), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text("Profile",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  XFile? file =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    Uint8List bytes = await file.readAsBytes();
                    UploadPicture().UploadImage(bytes, file.name).then((value) {
                      setState(() {
                        isUpload = value['location'].toString();
                        print(isUpload);
                      });
                    }).onError((error, StackTrace) {
                      print(error.toString());
                    });
                  }
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    shape: BoxShape.circle,
                  ),
                  child: isUpload.isEmpty
                      ? Container(child: const Icon(Icons.camera_alt_rounded))
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(isUpload),
                                fit: BoxFit.cover),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: w,
                child: Center(
                    child: Text(auth.email!,
                        style: const TextStyle(fontSize: 20))),
              ),
              const SizedBox(height: 20),
              Form(
                key: _form,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 235, 145, 145),
                      filled: true,
                      hintText: "UserName",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter profile name";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              RoundButton(
                  buttonname: "Update Profile",
                  tap: () {
                    print(auth.email!);
                    ref.doc(auth.email!.toString()).update({
                      "name": _nameController.text.toString(),
                      "profilePic": isUpload.toString(),
                    }).then((value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage()),
                          (route) => false);
                    }).onError((error, StackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Container(child: Text(error.toString())),
                      ));
                    });
                  }),
            ],
          ),
        ),
      ),
    ));
  }
}
