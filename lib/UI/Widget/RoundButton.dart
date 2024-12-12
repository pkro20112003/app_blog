import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoundButton extends StatelessWidget {
  final String buttonname;
  final VoidCallback tap;
  bool loading;
  RoundButton(
      {super.key,
      required this.buttonname,
      this.loading = false,
      required this.tap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 73, 72, 72),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: loading
                ? const CircularProgressIndicator()
                : Text(buttonname,
                    style: const TextStyle(color: Colors.white, fontSize: 20))),
      ),
    );
  }
}
