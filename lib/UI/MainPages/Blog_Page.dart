import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pratik_app/UI/MainPages/HomePage.dart';

// ignore: must_be_immutable
class BlogPage extends StatelessWidget {
  String Title;
  String Content;
  String image;
  String Profile;

  BlogPage(
      {super.key,
      required this.Content,
      required this.image,
      required this.Profile,
      required this.Title});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 210, 233, 99),
          title: TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false);
              },
              child: const Text("BlogEnjo", style: TextStyle(fontSize: 20))),
          automaticallyImplyLeading: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/back3.png"), fit: BoxFit.cover)),
          padding: const EdgeInsets.all(20),
          height: h,
          width: w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    width: w,
                    child: Text(Title,
                        style: GoogleFonts.protestRevolution(fontSize: 50))),
                SizedBox(
                    width: w,
                    child:
                        Text("by: " + Profile, style: TextStyle(fontSize: 20))),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  width: w,
                  child: Image.network(image),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: w,
                  child: Text(Content),
                ),
              ],
            ),
          ),
        ));
  }
}
