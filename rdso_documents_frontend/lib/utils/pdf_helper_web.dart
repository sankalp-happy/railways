// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

int _viewCounter = 0;

Future<Uint8List?> fetchPdfBytes(
    String url, Map<String, String> headers) async {
  const maxAttempts = 2;
  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) return response.bodyBytes;
      if (kDebugMode) {
        debugPrint('[fetchPdfBytes] HTTP ${response.statusCode} on attempt $attempt');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[fetchPdfBytes] attempt $attempt failed: $e');
      }
      if (attempt < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 500));
        continue;
      }
      rethrow;
    }
  }
  return null;
}

Future<String> savePdfFile(Uint8List bytes, String fileName) async {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
  return fileName;
}

Widget buildPdfViewer(Uint8List bytes) {
  final blob = html.Blob([bytes], 'application/pdf');
  final blobUrl = html.Url.createObjectUrlFromBlob(blob);
  final viewType = 'pdf-viewer-${_viewCounter++}';
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    return html.IFrameElement()
      ..src = blobUrl
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';
  });
  return HtmlElementView(viewType: viewType);
}

Future<void> openPdfFile(String path) async {
  // On web, files are auto-downloaded by the browser — no-op
}

Future<String> savePdfToTemp(Uint8List bytes, String fileName) async {
  return '';
}
