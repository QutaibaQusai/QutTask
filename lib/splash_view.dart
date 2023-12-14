import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quttask/home_screen.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Get.to(const HomeScreen());
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("3c42c6"),
        body: Center(
          child: Text(
            "QutTask",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
