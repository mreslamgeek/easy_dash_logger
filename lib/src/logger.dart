part of '../easy_dash_logger.dart';

// Conditional imports

extension ColoredLog on Object? {
  void printLog({
    String name = 'DEBUG_LOG',
    ANSICOLOR color = ANSICOLOR.yellow,
    ANSICOLOR? bgColor,
  }) {
    final String resetColor = ANSICOLOR.reset.colors;

    // Replace newline characters with ANSI escape sequence for newline
    final formattedMessage = toString().replaceAll(
      '\n',
      '$resetColor\n${bgColor == null ? resetColor : bgColor.colors[1]}${color.colors[0]}',
    );

    final logMessage =
        '${bgColor == null ? resetColor : bgColor.colors[1]}${color.colors[0]}$formattedMessage$resetColor';

    if (isDebugMode()) {
      // Use developer.log in debug mode
      dev.log(logMessage, name: name);
    } else {
      // Use print in release mode
      print(logMessage);
    }
  }
}
