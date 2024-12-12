import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pratik_app/UI/MainPages/HomePage.dart';
import 'package:pratik_app/UI/Widget/RoundButton.dart';
import 'package:pratik_app/Upload_image/UploadPicture.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});
  @override
  State<AddBlog> createState() => _AddBlog();
}

class _AddBlog extends State<AddBlog> {
  String isUpload = "";
  String name = "";
  final _picker = ImagePicker();
  final _formkey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final ref = FirebaseFirestore.instance.collection("blogs");
  final _auth = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchname();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 108, 197, 35),
          title: const Text("Create Blog"),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/back1.png"), fit: BoxFit.cover)),
          height: h,
          width: w,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: 150,
                      width: w,
                      child: const Image(
                        image: AssetImage("assets/c_b.png"),
                      )),
                  GestureDetector(
                    onTap: () async {
                      XFile? file =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (file != null) {
                        Uint8List bytes = await file.readAsBytes();
                        UploadPicture()
                            .UploadImage(bytes, file.name)
                            .then((value) {
                          setState(() {
                            isUpload = value['location'].toString();
                          });
                        }).onError((error, StackTrace) {
                          print(error.toString());
                        });
                      }
                    },
                    child: Container(
                      width: w,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: isUpload.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(30),
                              child: const Icon(Icons.camera_alt_rounded))
                          : Image(
                              image: NetworkImage(isUpload),
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                                hintText: "Title",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Title";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            minLines: 1,
                            maxLines: 50,
                            controller: _contentController,
                            decoration: InputDecoration(
                                hintText: "Content",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Content";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          RoundButton(
                              buttonname: "Upload",
                              tap: () {
                                if (_formkey.currentState!.validate()) {
                                  ref
                                      .doc(DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString())
                                      .set({
                                    "name": name,
                                    "title": _titleController.text.toString(),
                                    "content":
                                        _contentController.text.toString(),
                                    "contentPic": isUpload,
                                    "email": _auth.email.toString(),
                                    "blog id": DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
                                  }).then((value) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Container(
                                      child:
                                          const Text("Uploaded successfully"),
                                    )));
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomePage()),
                                        (route) => false);
                                    setState(() {
                                      isUpload = "";
                                    });
                                  }).onError((error, StackTrace) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Container(
                                      child: Text(error.toString()),
                                    )));
                                  });
                                }
                              }),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _fetchname() async {
    await FirebaseFirestore.instance
        .collection("profiles")
        .doc(_auth.email.toString())
        .get()
        .then((value) {
      setState(() {
        name = value["name"].toString();
      });
    }).onError((error, StackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
        child: Text(error.toString()),
      )));
    });
  }
}
