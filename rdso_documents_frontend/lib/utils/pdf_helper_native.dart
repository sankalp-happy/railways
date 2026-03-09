import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

Future<Uint8List?> fetchPdfBytes(
    String url, Map<String, String> headers) async {
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) return response.bodyBytes;
  return null;
}

Future<String> savePdfFile(Uint8List bytes, String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(bytes);
  return file.path;
}

Widget buildPdfViewer(Uint8List bytes) {
  return SfPdfViewer.memory(bytes);
}
