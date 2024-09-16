import 'package:easy_dash_logger/easy_dash_logger.dart';

void main() {
  // Log different levels of messages
  'This is a debug message'.printLog(name: 'CUSTOM_LOG', color: ANSICOLOR.green);
  'This is an info message'.printLog(name: 'CUSTOM_LOG', color: ANSICOLOR.blue);
  'This is a warning message'.printLog(name: 'CUSTOM_LOG', color: ANSICOLOR.yellow);
  'This is an error message'.printLog(name: 'CUSTOM_LOG', color: ANSICOLOR.red);

  // Log a message with additional context

  // Example usage of the ColoredLog extension
  'This is a colored log message'.printLog(
    name: 'CUSTOM_LOG',
    color: ANSICOLOR.green,
    bgColor: ANSICOLOR.white,
  );
}
