import 'dart:async';

import 'package:easy_dash_logger/easy_dash_logger.dart';
import 'package:easy_dash_logger/src/platform_specific_logger/dart_logger.dart';
import 'package:flutter_test/flutter_test.dart';

// Override the isDebugMode function for testing
bool Function() isDebugModeOverride = isDebugMode;

bool isDebugMode() {
  return isDebugModeOverride();
}

void main() {
  group('Logger Tests', () {
    test('Prints log in debug mode', () {
      const message = 'Test log message in debug mode';
      const name = 'DEBUG_LOG';
      const color = ANSICOLOR.green;
      const bgColor = ANSICOLOR.black;

      // Set debugMode to true
      debugMode = true;

      // Capture the log output
      final log = <String>[];
      final spec = ZoneSpecification(print: (_, __, ___, String msg) {
        log.add(msg);
      });

      // Run the test in a zone with the print interceptor
      runZoned(() {
        message.printLog(name: name, color: color, bgColor: bgColor);
      }, zoneSpecification: spec);

      // Verify the log output
      print('Log output: $log');
      expect(log, isNotEmpty);
      expect(log.any((msg) => msg.contains(message)), isTrue);
    });

    test('Prints log in release mode', () {
      const message = 'Test log message in release mode';
      const name = 'RELEASE_LOG';
      const color = ANSICOLOR.red;
      const bgColor = ANSICOLOR.blue;

      // Set debugMode to false
      debugMode = false;

      // Capture the print output
      final log = <String>[];
      final spec = ZoneSpecification(print: (_, __, ___, String msg) {
        log.add(msg);
      });

      // Run the test in a zone with the print interceptor
      runZoned(() {
        message.printLog(name: name, color: color, bgColor: bgColor);
      }, zoneSpecification: spec);

      // Verify the log output
      print('Log output: $log');
      expect(log, isNotEmpty);
      expect(log.any((msg) => msg.contains(message)), isTrue);
    });
  });
}
