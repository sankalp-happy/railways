import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

Future<Uint8List?> fetchPdfBytes(
    String url, Map<String, String> headers) async {
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) return response.bodyBytes;
  return null;
}

Future<String> savePdfFile(Uint8List bytes, String fileName) async {
  Directory? baseDir;
  
  if (Platform.isAndroid) {
    if (await Permission.storage.request().isGranted || await Permission.manageExternalStorage.request().isGranted) {
      baseDir = Directory('/storage/emulated/0/RDSO/Downloads');
      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
      }
    } else {
      // Fallback if permission denied
      baseDir = await getExternalStorageDirectory();
    }
  } else if (Platform.isWindows) {
    baseDir = await getDownloadsDirectory();
    if (baseDir != null) {
      baseDir = Directory('${baseDir.path}/RDSO');
      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
      }
    }
  }

  if (baseDir == null) {
    baseDir = await getApplicationDocumentsDirectory();
  }

  final file = File('${baseDir.path}/$fileName');
  await file.writeAsBytes(bytes);
  return file.path;
}

Widget buildPdfViewer(Uint8List bytes) {
  return SfPdfViewer.memory(bytes);
}
