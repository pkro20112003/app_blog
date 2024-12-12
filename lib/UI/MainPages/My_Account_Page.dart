import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pratik_app/UI/Add_Blog/Add_Blog.dart';
import 'package:pratik_app/UI/MainPages/Blog_Page.dart';
import 'package:pratik_app/UI/MainPages/HomePage.dart';
import 'package:pratik_app/Upload_image/UploadPicture.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});
  @override
  State<MyAccountPage> createState() => _MyAccountPage();
}

class _MyAccountPage extends State<MyAccountPage> {
  String email = "";
  String ProPic = "";
  String name = "";

  final _nameUpdateController = TextEditingController();
  final _auth = FirebaseAuth.instance.currentUser!;
  final ref = FirebaseFirestore.instance.collection("profiles");
  final blogs = FirebaseFirestore.instance;
  final _picker = ImagePicker();
  String isUpload = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: const Color.fromARGB(255, 33, 243, 177),
        automaticallyImplyLeading: true,
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                DailogBoxProfile(context);
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/back3.png"), fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                child: ProPic.isEmpty
                    ? const CircleAvatar(
                        radius: 40, child: Icon(Icons.camera_alt))
                    : CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(ProPic),
                      ),
              ),
              const SizedBox(height: 10),
              Container(
                  color: const Color.fromARGB(255, 51, 232, 174),
                  width: w,
                  child: Column(
                    children: [
                      Container(
                        child: name.isEmpty
                            ? Container()
                            : Container(
                                child: Text(
                                name,
                                style: const TextStyle(fontSize: 20),
                              )),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: email.isEmpty
                            ? Container()
                            : Container(
                                child: Text(
                                email,
                                style: const TextStyle(fontSize: 20),
                              )),
                      ),
                    ],
                  )),
              const SizedBox(height: 10),
              SizedBox(
                  width: w,
                  child: Text("Your Blogs: ",
                      style: GoogleFonts.libreFranklin(
                          textStyle: const TextStyle(
                        fontSize: 30,
                      )))),
              Container(
                  child: Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("blogs")
                    .where("email", isEqualTo: _auth.email)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Error");
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BlogPage(
                                            Content: snapshot
                                                .data!.docs[index]["content"]
                                                .toString(),
                                            image: snapshot
                                                .data!.docs[index]["contentPic"]
                                                .toString(),
                                            Profile: snapshot
                                                .data!.docs[index]["name"]
                                                .toString(),
                                            Title: snapshot
                                                .data!.docs[index]["title"]
                                                .toString()))).then((value) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Container(
                                    child: const Text("route done"),
                                  )));
                                }).onError((error, StackTrace) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Container(
                                    child: Text(error.toString()),
                                  )));
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              trailing: Image(
                                image: NetworkImage(snapshot
                                    .data!.docs[index]["contentPic"]
                                    .toString()),
                                fit: BoxFit.cover,
                              ),
                              tileColor: Colors.amber,
                              subtitle: Text(
                                  "by: ${snapshot.data!.docs[index]["name"]}"),
                              title: Text(snapshot.data!.docs[index]["title"]
                                  .toString()),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                        child: Text("no data found!",
                            style: TextStyle(fontSize: 20)));
                  }
                },
              ))),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AddBlog()));
          },
          child: const Icon(Icons.add)),
    );
  }

  Future<dynamic> DailogBoxProfile(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
            child: SizedBox(
                height: 250,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          XFile? file = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (file != null) {
                            Uint8List bytes = await file.readAsBytes();
                            UploadPicture()
                                .UploadImage(bytes, file.name)
                                .then((value) {
                              setState(() {
                                isUpload = value['location'].toString();
                              });
                              ref.doc(email).update({
                                "profilePic": isUpload,
                              });
                            }).onError((error, StackTrace) {
                              print(error.toString());
                            });
                          }
                        },
                        child: Container(
                          child: isUpload.isEmpty
                              ? const CircleAvatar(
                                  radius: 50, child: Icon(Icons.camera_alt))
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(isUpload),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        tileColor: const Color.fromARGB(255, 33, 243, 177),
                        title: Text(
                          "name: $name",
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              DailogBoxName(context);
                            },
                            icon: const Icon(Icons.edit)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]))));
  }

  Future<dynamic> DailogBoxName(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("profile Name Update"),
              content: TextFormField(
                controller: _nameUpdateController,
                decoration: InputDecoration(
                  hintText: "UserName",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (_nameUpdateController.text.toString().isNotEmpty) {
                        ref.doc(email).update({
                          "name": _nameUpdateController.text.toString(),
                        }).then((value) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Container(
                            child: const Text("Name Updated"),
                          )));
                        }).onError((error, StackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Container(
                            child: Text(error.toString()),
                          )));
                        });
                      }
                    },
                    child: const Text("update"))
              ],
            ));
  }

  Future<void> _fetch() async {
    FirebaseFirestore.instance
        .collection("profiles")
        .doc(_auth.email.toString())
        .get()
        .then((val) {
      setState(() {
        email = val["email"].toString();
        ProPic = val["profilePic"].toString();
        name = val["name"].toString();
      });
    }).onError((error, StackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Container(child: Text(error.toString()))));
    });
  }
}
