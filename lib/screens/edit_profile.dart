import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_handler/controller/balance_controller.dart';
import 'package:money_handler/controller/image_controller.dart';
import 'package:money_handler/firebase/FirebaseUtils.dart';
import 'package:money_handler/models/user_model.dart';
import 'package:money_handler/utils/ColorsUtil.dart';
import 'package:money_handler/widgets/Textformfield.dart';
import 'package:money_handler/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_handler/widgets/circular_avatar.dart';
import '../utils/Utils.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var cu = FirebaseUtils.cu;

  TextEditingController name = TextEditingController();

  final imageController = Get.put(ImageController());

  final balanceController = Get.put(BalanceController());

  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    balanceController.getUserdata();
    var data = balanceController.user.value;
    name.text = data?["name"];

    return Scaffold(
      backgroundColor: ColorsUtil.darkBg,
      appBar: AppBar(
        backgroundColor: ColorsUtil.darkBg,
        foregroundColor: ColorsUtil.lightBg,
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stack(
          //   children: [
          //     Container(
          //       clipBehavior: Clip.antiAlias,
          //       height: 150,
          //       width: 150,
          //       decoration: const BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: Color(0xffFAC0D4),
          //       ),
          //       // child: Obx(
          //       //   () => imageController.image.value.isEmpty
          //       //       ? Image.network(
          //       //           data?["image"] ?? '',
          //       //           fit: BoxFit.cover,
          //       //           frameBuilder:
          //       //               (context, child, frame, wasSynchronouslyLoaded) {
          //       //             if (frame == null) {
          //       //               return const Center(
          //       //                 child: CircularProgressIndicator(),
          //       //               );
          //       //             }
          //       //             return child;
          //       //           },
          //       //         )
          //       //       : Image.file(
          //       //           File(imageController.image.value),
          //       //           fit: BoxFit.cover,
          //       //           width: 150,
          //       //           height: 150,
          //       //           filterQuality: FilterQuality.low,
          //       //           frameBuilder:
          //       //               (context, child, frame, wasSynchronouslyLoaded) {
          //       //             if (frame == null) {
          //       //               return const Center(
          //       //                 child: CircularProgressIndicator(),
          //       //               );
          //       //             }
          //       //             return child;
          //       //           },
          //       //         ),
          //       // ),
          //     ),
          //     Positioned(
          //       bottom: 0,
          //       right: 0,
          //       child: IconButton(
          //         onPressed: () {
          //           imageController.addcameraimage();
          //         },
          //         icon: const Icon(
          //           Icons.photo_camera,
          //           color: Colors.grey,
          //           size: 25,
          //         ),
          //       ),
          //     ),
          //     Positioned(
          //       bottom: 0,
          //       left: 0,
          //       child: IconButton(
          //         onPressed: () {
          //           imageController.addgalleryimage();
          //         },
          //         icon: const Icon(
          //           Icons.photo,
          //           color: Colors.grey,
          //           size: 25,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Obx(
            ()=> Circularavatar(
              fileImageurl: imageController.image.value,
              networkimageUrl: data?["image"],
              camera: () {
                imageController.addcameraimage();
              },
              gallery: () {
                imageController.addgalleryimage();
              },
              isImage: true,
            ),
          ),
          const SizedBox(height: 20),
          TextformField(
            textController: name,
            hinttext: "",
            isPadding: true,
            validator: (value) {
              return null;
            },
          ),
          const SizedBox(height: 20),
          Obx(
            () => Button(
              text: "Edit",
              onTap: () async {
                isLoading.value = true;
                var imageStorage = imageController.image.value.isEmpty
                    ? data!["image"]
                    : await Utils.imageStorage(
                        imageController.image.value,
                      );
                AuthUser authuser = AuthUser(
                    name: name.text,
                    image: imageStorage.toString(),
                    email: cu?.email);
                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(cu?.uid)
                    .update(
                      authuser.toJson(),
                    );

                await cu?.updatePhotoURL(imageStorage.toString());
                await cu?.updateDisplayName(name.text);
                balanceController.getUserdata();
                Get.back();
              },
              bRadius: 10,
              isLoading: isLoading.value,
              buttonStyle: Buttonstyle.secondary,
              height: 40,
              textColor: Colors.white,
              width: 100,
            ),
          ),
        ],
      ),
    );
  }
}
