import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<void> saveFile(File file, String fileName) async {
  Directory d = await getExternalStorageDirectory();
  if (!(await Directory('${d.path}/documents').exists()))
    await Directory('${d.path}/documents').create(recursive: true);
  file.copy('${d.path}/documents/$fileName');
}
