import 'package:easy_dash_logger/easy_dash_logger.dart';
import 'package:easy_dash_logger/src/platform_specific_logger/is_dart.dart'
    if (dart.library.ui) 'package:easy_dash_logger/src/platform_specific_logger/is_flutter.dart';
import 'package:test/test.dart';

void main() {
  final captured = <String>[];

  setUp(() {
    captured.clear();
    EasyDashLoggerConfig.reset();
    EasyDashLoggerConfig.configure(
      output: (message, name) => captured.add('$name|$message'),
    );
  });

  tearDown(EasyDashLoggerConfig.reset);

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

  group('Config', () {
    test('logs are visible in debug builds only by default', () {
      EasyDashLoggerConfig.reset();
      expect(EasyDashLoggerConfig.showLogsInDebug, isTrue);
      expect(EasyDashLoggerConfig.showLogsInProfile, isFalse);
      expect(EasyDashLoggerConfig.showLogsInRelease, isFalse);
      expect(EasyDashLoggerConfig.isLoggingEnabled, kLoggerDebugMode);
      expect(kLoggerDebugMode, !kLoggerReleaseMode && !kLoggerProfileMode);
    });

    test('isLoggingEnabled follows the flag for the current build mode', () {
      EasyDashLoggerConfig.configure(
        showLogsInDebug: false,
        showLogsInProfile: false,
        showLogsInRelease: false,
      );
      expect(EasyDashLoggerConfig.isLoggingEnabled, isFalse);

      // Only the flag matching the running build mode can turn logging back on.
      if (kLoggerReleaseMode) {
        EasyDashLoggerConfig.configure(showLogsInRelease: true);
      } else if (kLoggerProfileMode) {
        EasyDashLoggerConfig.configure(showLogsInProfile: true);
      } else {
        EasyDashLoggerConfig.configure(showLogsInDebug: true);
      }
      expect(EasyDashLoggerConfig.isLoggingEnabled, isTrue);
    });

    test('a flag for another build mode does not enable logging here', () {
      EasyDashLoggerConfig.silenceAll();
      EasyDashLoggerConfig.configure(showLogsInRelease: !kLoggerReleaseMode);
      expect(EasyDashLoggerConfig.isLoggingEnabled, isFalse);
      'wrong mode'.printLog();
      expect(captured, isEmpty);
    });

    test('silenceAll stops output in every build mode', () {
      EasyDashLoggerConfig.silenceAll();
      'silenced'.printLog();
      expect(captured, isEmpty);
      expect(EasyDashLoggerConfig.isLoggingEnabled, isFalse);
    });

    test('re-enabling emits again', () {
      EasyDashLoggerConfig.silenceAll();
      'silenced'.printLog();
      EasyDashLoggerConfig.configure(showLogsInDebug: true);
      'audible'.printLog();
      expect(captured, hasLength(1));
      expect(captured.single, contains('audible'));
    });

    test('custom output receives name and message', () {
      EasyDashLoggerConfig.configure(useColors: false);
      'hello'.printLog(name: 'SINK');
      expect(captured.single, 'SINK|hello');
    });

    test('useColors: false strips ANSI codes', () {
      EasyDashLoggerConfig.configure(useColors: false);
      'plain'.printLog(color: ANSICOLOR.red, bgColor: ANSICOLOR.blue);
      expect(captured.single, isNot(contains('\x1B[')));
    });

    test('useColors: true wraps the message in ANSI codes', () {
      EasyDashLoggerConfig.configure(useColors: true);
      'fancy'.printLog(color: ANSICOLOR.red);
      expect(captured.single, contains(ANSICOLOR.red.colors[0]));
      expect(captured.single, endsWith(ANSICOLOR.reset.colors));
    });

    test('configured defaults are used when a call site omits them', () {
      EasyDashLoggerConfig.configure(useColors: false, defaultName: 'APP');
      'defaulted'.printLog();
      expect(captured.single, 'APP|defaulted');
    });

    test('multiline messages keep coloring per line', () {
      EasyDashLoggerConfig.configure(useColors: true);
      'line1\nline2'.printLog(color: ANSICOLOR.green);
      expect(captured.single, contains('line1'));
      expect(captured.single, contains('line2'));
      expect(captured.single.split('\n'), hasLength(2));
    });

    test('reset restores defaults', () {
      EasyDashLoggerConfig.configure(
        showLogsInDebug: false,
        showLogsInProfile: true,
        showLogsInRelease: true,
        defaultName: 'X',
        defaultColor: ANSICOLOR.pink,
        defaultBgColor: ANSICOLOR.black,
      );
      EasyDashLoggerConfig.reset();
      expect(EasyDashLoggerConfig.showLogsInDebug, isTrue);
      expect(EasyDashLoggerConfig.showLogsInProfile, isFalse);
      expect(EasyDashLoggerConfig.showLogsInRelease, isFalse);
      expect(EasyDashLoggerConfig.defaultName, 'DEBUG_LOG');
      expect(EasyDashLoggerConfig.defaultColor, ANSICOLOR.yellow);
      expect(EasyDashLoggerConfig.defaultBgColor, isNull);
      expect(EasyDashLoggerConfig.output, isNull);
    });
  });
}
