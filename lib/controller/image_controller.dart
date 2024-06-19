import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  ImagePicker picker = ImagePicker();
  RxString image = ''.obs;

  void addcameraimage() async {
    final pickedfile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedfile != null) {
      image.value = pickedfile.path;
    }
  }

  void addgalleryimage() async {
    final pickedfile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedfile != null) {
      image.value = pickedfile.path;
    }
  }
}
