import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

bool isFlutterEnvironment() {
  try {
    // If this line does not throw, we are in a Flutter environment
    ui.PlatformDispatcher.instance;
    return true;
  } catch (e) {
    return false;
  }
}

bool isDebugMode() {
  return kDebugMode;
}
