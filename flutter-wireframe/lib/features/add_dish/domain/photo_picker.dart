import 'package:image_picker/image_picker.dart';

abstract interface class PhotoPicker {
  Future<String?> pick(ImageSource source);
}
