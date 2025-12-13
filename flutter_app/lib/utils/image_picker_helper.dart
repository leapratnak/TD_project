import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker picker = ImagePicker();

  // Mobile
  static Future<File?> pickImageMobile() async {
    if (kIsWeb) return null;
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    return picked != null ? File(picked.path) : null;
  }

  // Web
  static Future<Uint8List?> pickImageWeb() async {
    if (!kIsWeb) return null;
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    return picked != null ? await picked.readAsBytes() : null;
  }
}
