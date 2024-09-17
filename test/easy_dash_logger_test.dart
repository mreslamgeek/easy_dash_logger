import 'package:easy_dash_logger/easy_dash_logger.dart';
import 'package:easy_dash_logger/src/platform_specific_logger/is_dart.dart'
    if (dart.library.ui) 'package:easy_dash_logger/src/platform_specific_logger/is_flutter.dart';
import 'package:test/test.dart';

void main() {
  group('EasyDashLogger Tests', () {
    test('Default log message', () {
      expect(() => 'This is a default log message'.printLog(), returnsNormally);
    });

    test('Custom log message', () {
      expect(
          () => 'This is a custom log message'.printLog(
                name: 'CUSTOM_LOG',
                color: ANSICOLOR.green,
              ),
          returnsNormally);
    });

    test('Log message with background color', () {
      expect(
          () => 'This is a log message with background color'.printLog(
                color: ANSICOLOR.red,
                bgColor: ANSICOLOR.lightYellow,
              ),
          returnsNormally);
    });

    test('Log message in Flutter environment', () {
      if (isFlutter()) {
        expect(
            () => 'This is a log message in Flutter'.printLog(
                  name: 'FLUTTER_LOG',
                  color: ANSICOLOR.blue,
                ),
            returnsNormally);
      } else {
        expect(
            () => 'This is a log message in Dart'.printLog(
                  name: 'DART_LOG',
                  color: ANSICOLOR.purple,
                ),
            returnsNormally);
      }
    });
  });
}
