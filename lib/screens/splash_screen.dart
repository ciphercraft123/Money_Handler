import 'dart:async';
import 'package:money_handler/screens/authentication/login_screen.dart';
import 'package:money_handler/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var cu = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        Get.off(
          cu != null ? const HomePage() : const LoginScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'image',
        child: Image.asset(
          "assets/expense icon.png",
          height: 180,
          width: 180,
        ),
      ),
    );
  }
}
