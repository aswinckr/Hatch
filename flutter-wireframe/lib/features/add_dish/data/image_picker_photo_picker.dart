import 'package:image_picker/image_picker.dart';

import '../domain/photo_picker.dart';

class ImagePickerPhotoPicker implements PhotoPicker {
  ImagePickerPhotoPicker([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String?> pick(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 88);
    return file?.path;
  }
}
