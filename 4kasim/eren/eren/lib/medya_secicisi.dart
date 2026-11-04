import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MedyaSeciciServisi {
  final ImagePicker _picker = ImagePicker();

  Future<File?> galeridenSec() async {
    final XFile? secilen = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (secilen == null) return null;
    return File(secilen.path);
  }
}
