import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PageviewController extends GetxController {
  var currentIndex = 0.obs;
  final pageController = PageController().obs;

  void changePage(int index) {
    currentIndex.value = index;
    pageController.value.jumpToPage(index);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
