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
  dynamic get colors {
    switch (this) {
      case ANSICOLOR.reset:
        return '\x1B[0m';
      case ANSICOLOR.black:
        return ['\x1B[30m', '\x1B[40m'];
      case ANSICOLOR.red:
        return ['\x1B[31m', '\x1B[41m'];
      case ANSICOLOR.green:
        return ['\x1B[32m', '\x1B[42m'];
      case ANSICOLOR.yellow:
        return ['\x1B[33m', '\x1B[43m'];
      case ANSICOLOR.purple:
        return ['\x1B[35m', '\x1B[45m'];
      case ANSICOLOR.blue:
        return ['\x1B[34m', '\x1B[44m'];
      case ANSICOLOR.cyan:
        return ['\x1B[36m', '\x1B[46m'];
      case ANSICOLOR.white:
        return ['\x1B[37m', '\x1B[47m'];
      case ANSICOLOR.orange:
        return ['\x1B[38;5;208m', '\x1B[48;5;208m'];
      case ANSICOLOR.pink:
        return ['\x1B[38;5;213m', '\x1B[48;5;213m'];
      case ANSICOLOR.lightBlue:
        return ['\x1B[38;5;117m', '\x1B[48;5;117m'];
      case ANSICOLOR.lightGreen:
        return ['\x1B[38;5;120m', '\x1B[48;5;120m'];
      case ANSICOLOR.lightRed:
        return ['\x1B[38;5;203m', '\x1B[48;5;203m'];
      case ANSICOLOR.lightYellow:
        return ['\x1B[38;5;227m', '\x1B[48;5;227m'];
      case ANSICOLOR.brightRed:
        return ['\x1B[38;5;196m', '\x1B[48;5;196m'];
      case ANSICOLOR.brightGreen:
        return ['\x1B[38;5;46m', '\x1B[48;5;46m'];
      case ANSICOLOR.brightCyan:
        return ['\x1B[38;5;51m', '\x1B[48;5;51m'];
      case ANSICOLOR.brightMagenta:
        return ['\x1B[38;5;201m', '\x1B[48;5;201m'];
      default:
        return null;
    }
  }
}
