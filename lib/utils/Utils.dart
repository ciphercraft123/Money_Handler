import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  Utils._();

  static showSnackbar(String message, Duration duration, Color color,
      {SnackBarAction? action}) {
    ScaffoldMessenger.of(Get.context!)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          content: Text(message),
          backgroundColor: color,
          action: action,
        ),
      );
  }

  static Future<String> imageStorage(String image) async {
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef =
        FirebaseStorage.instance.ref().child("Profile_Picture/$imageName.png");
    final i = await storageRef.putFile(
      File(image),
      SettableMetadata(contentType: 'image/png'),
    );

    final path = await i.ref.getDownloadURL();
    return path;
  }
}
