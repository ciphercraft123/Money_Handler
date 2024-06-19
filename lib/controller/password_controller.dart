import 'package:get/get.dart';

class PasswordController extends GetxController{
  RxBool isShow = true.obs;

  void passwordToggle(){
    isShow.value = !isShow.value;
  }
}