import 'package:file_picker/file_picker.dart';

class MediaService {
  MediaService() {}

  Future<PlatformFile?> pickImageFromLibrary() async {
    print("entered");
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    print("picked the file");
    if (_result != null) {
      print("_result is not null");
      return _result.files[0];
    }
    return null;
  }
}
