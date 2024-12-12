import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pratik_app/UI/Add_Blog/Add_Blog.dart';
import 'package:pratik_app/UI/Login_Signup/Login.dart';
import 'package:pratik_app/UI/MainPages/Blog_Page.dart';
import 'package:pratik_app/UI/MainPages/My_Account_Page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HMPage();
}

class HMPage extends State<HomePage> {
  int bottomindex = 0;
  String name = "";
  String ProPic = "";
  final _auth = FirebaseAuth.instance.currentUser;

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
      backgroundColor: const Color.fromRGBO(96, 168, 228, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "BlogEnjo",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 56, 102),
        actions: [
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => Dialog(
                      child: SizedBox(
                          height: 300,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                child: ProPic.isEmpty
                                    ? const CircleAvatar(
                                        radius: 50,
                                        child: Icon(Icons.camera_alt))
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(ProPic),
                                      ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                  child: name.isEmpty
                                      ? Container(
                                          child: const Text("____________"),
                                        )
                                      : Expanded(
                                          child: Container(
                                              child: Text("hi! $name",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        )),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 186, 229, 136),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const MyAccountPage()));
                                      },
                                      child: const Text(
                                        "My Account",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 186, 229, 136),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Login()),
                                            (route) => false);
                                      },
                                      child: const Text(
                                        "Sign out",
                                        style: TextStyle(color: Colors.black),
                                      ))
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ))));
            },
            child: ProPic.isEmpty
                ? const CircleAvatar(child: Icon(Icons.camera_alt))
                : CircleAvatar(
                    backgroundImage: NetworkImage(ProPic),
                  ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SizedBox(
          height: h,
          width: w,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              child: Column(
                children: [
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("blogs")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  trailing: Image(
                                    image: NetworkImage(snapshot
                                        .data!.docs[index]["contentPic"]
                                        .toString()),
                                    fit: BoxFit.cover,
                                  ),
                                  tileColor:
                                      const Color.fromRGBO(7, 25, 185, 1),
                                  subtitle: Text(
                                    "by: ${snapshot.data!.docs[index]["name"]}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  title: Text(
                                    snapshot.data!.docs[index]["title"]
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => BlogPage(
                                                Content: snapshot.data!
                                                    .docs[index]["content"]
                                                    .toString(),
                                                image: snapshot.data!
                                                    .docs[index]["contentPic"]
                                                    .toString(),
                                                Profile: snapshot
                                                    .data!.docs[index]["name"]
                                                    .toString(),
                                                Title: snapshot
                                                    .data!.docs[index]["title"]
                                                    .toString()))).then(
                                        (value) {
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
                                ),
                              );
                            });
                      } else {
                        return const Center(
                            child: Text("no data found!",
                                style: TextStyle(fontSize: 20)));
                      }
                    },
                  )),
                ],
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AddBlog()));
        },
        backgroundColor: const Color.fromRGBO(7, 25, 185, 1),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _fetch() async {
    if (_auth != null) {
      await FirebaseFirestore.instance
          .collection("profiles")
          .doc(_auth.email.toString())
          .get()
          .then((value) {
        setState(() {
          ProPic = value["profilePic"].toString();
          name = value["name"].toString();
        });
        print(ProPic);
      }).onError((error, StackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Container(
          child: Text(error.toString()),
        )));
      });
    }
  }
}
