import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_handler/controller/image_controller.dart';

class Circularavatar extends StatelessWidget {
  final bool isImage;
  final String networkimageUrl;
  final String fileImageurl;
  final void Function() camera;
  final void Function() gallery;

  Circularavatar(
      {super.key,
      this.isImage = false,
      this.networkimageUrl = '',
      this.fileImageurl = '',
      required this.camera,
      required this.gallery});

  final imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          maxRadius: 70,
          backgroundImage: fileImageurl.isNotEmpty
              ? FileImage(
                  File(fileImageurl),
                )
              : (isImage && networkimageUrl.isNotEmpty
                  ? NetworkImage(networkimageUrl)
                  : null),
          child: !isImage && fileImageurl.isEmpty
              ? Icon(
                  Icons.person,
                  size: 80,
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            onPressed: camera,
            icon: const Icon(
              Icons.photo_camera,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: IconButton(
            onPressed:gallery,
            icon: const Icon(
              Icons.photo,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }
}
