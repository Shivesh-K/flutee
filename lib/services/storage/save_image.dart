import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<void> saveImage(File image, String fileName) async {
  Directory d = await getExternalStorageDirectory();
  if (!(await Directory('${d.path}/images').exists()))
    await Directory('${d.path}/images').create(recursive: true);
  image.copy('${d.path}/images/$fileName');
}
