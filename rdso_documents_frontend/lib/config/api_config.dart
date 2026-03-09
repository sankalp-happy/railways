import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) return 'http://52.140.125.36:7146/api';
    if (Platform.isAndroid) return 'http://52.140.125.36:7146/api';
    return 'http://52.140.125.36:7146/api';
  }
}
