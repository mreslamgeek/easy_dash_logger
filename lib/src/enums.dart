part of '../easy_dash_logger.dart';

/// Enum representing ANSI color codes.
enum ANSICOLOR {
  reset,
  black,
  white,
  red,
  green,
  yellow,
  blue,
  cyan,
  purple,
  orange,
  pink,
  lightBlue,
  lightGreen,
  lightRed,
  lightYellow,
  brightRed,
  brightGreen,
  brightCyan,
  brightMagenta;

  /// Returns the ANSI color codes for the enum value.
  dynamic get colors => switch (this) {
        ANSICOLOR.reset => '\x1B[0m',
        ANSICOLOR.black => ['\x1B[30m', '\x1B[40m'],
        ANSICOLOR.red => ['\x1B[31m', '\x1B[41m'],
        ANSICOLOR.green => ['\x1B[32m', '\x1B[42m'],
        ANSICOLOR.yellow => ['\x1B[33m', '\x1B[43m'],
        ANSICOLOR.purple => ['\x1B[35m', '\x1B[45m'],
        ANSICOLOR.blue => ['\x1B[34m', '\x1B[44m'],
        ANSICOLOR.cyan => ['\x1B[36m', '\x1B[46m'],
        ANSICOLOR.white => ['\x1B[37m', '\x1B[47m'],
        ANSICOLOR.orange => ['\x1B[38;5;208m', '\x1B[48;5;208m'],
        ANSICOLOR.pink => ['\x1B[38;5;213m', '\x1B[48;5;213m'],
        ANSICOLOR.lightBlue => ['\x1B[38;5;117m', '\x1B[48;5;117m'],
        ANSICOLOR.lightGreen => ['\x1B[38;5;120m', '\x1B[48;5;120m'],
        ANSICOLOR.lightRed => ['\x1B[38;5;203m', '\x1B[48;5;203m'],
        ANSICOLOR.lightYellow => ['\x1B[38;5;227m', '\x1B[48;5;227m'],
        ANSICOLOR.brightRed => ['\x1B[38;5;196m', '\x1B[48;5;196m'],
        ANSICOLOR.brightGreen => ['\x1B[38;5;46m', '\x1B[48;5;46m'],
        ANSICOLOR.brightCyan => ['\x1B[38;5;51m', '\x1B[48;5;51m'],
        ANSICOLOR.brightMagenta => ['\x1B[38;5;201m', '\x1B[48;5;201m']
      };
}
