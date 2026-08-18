part of '../easy_dash_logger.dart';

/// Extension on [Object] to provide logging functionality.
extension ColoredLog on Object? {
  /// Prints a log message with the specified [name], [color], and optional [bgColor].
  ///
  /// Nothing is emitted — and no string is built — unless
  /// [EasyDashLoggerConfig.isLoggingEnabled] is `true`. Logs are shown in debug
  /// builds only by default; use [EasyDashLoggerConfig.configure] with
  /// `showLogsInRelease` / `showLogsInProfile` before the app starts to change
  /// that.
  ///
  /// [name] defaults to [EasyDashLoggerConfig.defaultName] ('DEBUG_LOG').
  /// [color] defaults to [EasyDashLoggerConfig.defaultColor] (yellow).
  /// [bgColor] defaults to [EasyDashLoggerConfig.defaultBgColor] (none).
  void printLog({
    String? name,
    ANSICOLOR? color,
    ANSICOLOR? bgColor,
  }) {
    if (!EasyDashLoggerConfig.isLoggingEnabled) return;

    final String logName = name ?? EasyDashLoggerConfig.defaultName;
    final String message = toString();
    final String logMessage;

    if (EasyDashLoggerConfig.useColors) {
      final String resetColor = ANSICOLOR.reset.colors;
      final String fgColor =
          (color ?? EasyDashLoggerConfig.defaultColor).colors[0];
      final ANSICOLOR? background = bgColor ?? EasyDashLoggerConfig.defaultBgColor;
      final String bg = background == null ? resetColor : background.colors[1];

      final formattedMessage =
          message.replaceAll('\n', '$resetColor\n$bg$fgColor');

      logMessage = '$bg$fgColor$formattedMessage$resetColor';
    } else {
      logMessage = message;
    }

    final LogOutput? output = EasyDashLoggerConfig.output;
    if (output != null) {
      output(logMessage, logName);
    } else if (isFlutter() && !kLoggerIsWeb) {
      dev.log(logMessage, name: logName);
    } else {
      // ignore: avoid_print
      print('[$logName] $logMessage');
    }
  }
}
