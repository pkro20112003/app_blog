import 'package:flutter/material.dart';
import 'package:pratik_app/UI/Splash_Screen/Splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _StartingScreen();
}

class _StartingScreen extends State<SplashScreen> {
  SplashService service = SplashService();
  @override
  initState() {
    super.initState();
    service.SplashTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 29, 51),
          automaticallyImplyLeading: true,
        ),
        backgroundColor: const Color.fromARGB(255, 2, 29, 51),
        body: Container(
            decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/logo.png")),
        )));
  }
}
