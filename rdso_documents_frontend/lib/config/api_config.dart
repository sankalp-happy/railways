import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) return 'http://10.13.0.150:8000/api';
    if (Platform.isAndroid) return 'http://10.13.0.150:8000/api';
    return 'http://10.13.0.150:8000/api';
  }
}
