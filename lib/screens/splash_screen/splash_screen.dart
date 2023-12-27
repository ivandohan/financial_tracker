// ignore_for_file: use_build_context_synchronously

import 'package:fin_trackr/constants/constant.dart';
import 'package:fin_trackr/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _navigateHome();
    super.initState();
  }

  _navigateHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // ImageProvider logo = const AssetImage("assets/image/appLogo.png");
    return Scaffold(
      backgroundColor: AppColor.ftScaffoldColor,
      body: Container(
        color: AppColor.ftScaffoldColor,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: size.width,
                child: Text(
                  AppText.appName,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.ubuntu().fontFamily,
                    color: AppColor.ftWaveColor,
                  ),
                ),
              ),
              const Positioned(
                bottom: 35,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 72,
                          height: 39.36,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
