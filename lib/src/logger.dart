part of '../easy_dash_logger.dart';

/// Extension on [Object] to provide logging functionality.
extension ColoredLog on Object? {
  /// Prints a log message with the specified [name], [color], and optional [bgColor].
  ///
  /// The [name] defaults to 'DEBUG_LOG'.
  /// The [color] defaults to [ANSICOLOR.yellow].
  /// The [bgColor] is optional.
  void printLog({
    String name = 'DEBUG_LOG',
    ANSICOLOR color = ANSICOLOR.yellow,
    ANSICOLOR? bgColor,
  }) {
    final String resetColor = ANSICOLOR.reset.colors;

    final formattedMessage = toString().replaceAll(
      '\n',
      '$resetColor\n${bgColor == null ? resetColor : bgColor.colors[1]}${color.colors[0]}',
    );

    final logMessage =
        '${bgColor == null ? resetColor : bgColor.colors[1]}${color.colors[0]}$formattedMessage$resetColor';

    if (isFlutter()) {
      dev.log(logMessage, name: name);
    } else {
      print(logMessage);
    }
  }
}
