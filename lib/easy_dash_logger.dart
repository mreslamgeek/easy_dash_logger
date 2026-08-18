/// Colored, named logging for Dart and Flutter.
///
/// Log any object with the [ColoredLog.printLog] extension:
///
/// ```dart
/// 'Server responded in 42ms'.printLog(name: 'API', color: ANSICOLOR.green);
/// ```
///
/// Logs are shown in debug builds only by default — release and profile builds
/// stay silent. Use [EasyDashLoggerConfig] to change that, along with the
/// default name and colors or a custom log sink, before the app starts:
///
/// ```dart
/// void main() {
///   EasyDashLoggerConfig.configure(showLogsInRelease: true);
///   runApp(const MyApp());
/// }
/// ```
library easy_dash_logger;

import 'dart:developer' as dev;

import 'src/platform_specific_logger/is_dart.dart'
    if (dart.library.ui) 'src/platform_specific_logger/is_flutter.dart';

part 'src/enums.dart';
part 'src/config.dart';
part 'src/logger.dart';
