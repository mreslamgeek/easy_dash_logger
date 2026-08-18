import 'package:easy_dash_logger/easy_dash_logger.dart';

void main() {
  // Logs are shown in debug builds only by default — profile and release
  // builds stay silent. Configure before anything else runs, e.g. before
  // runApp().
  EasyDashLoggerConfig.configure(
    defaultName: 'CUSTOM_LOG',
  );

  // Log different levels of messages
  'This is a debug message'.printLog(color: ANSICOLOR.green);
  'This is an info message'.printLog(color: ANSICOLOR.blue);
  'This is a warning message'.printLog(color: ANSICOLOR.yellow);
  'This is an error message'.printLog(color: ANSICOLOR.red);

  // Example usage of the ColoredLog extension
  'This is a colored log message'.printLog(
    name: 'CUSTOM_LOG',
    color: ANSICOLOR.green,
    bgColor: ANSICOLOR.white,
  );

  // Opt in to logs in a shipped app — e.g. behind a QA or support switch.
  EasyDashLoggerConfig.configure(showLogsInRelease: true);
  'Visible even in a release build'.printLog(color: ANSICOLOR.cyan);

  // Mute everything at runtime, in every build mode.
  EasyDashLoggerConfig.silenceAll();
  'Never printed'.printLog();

  // Route logs somewhere else instead of the console.
  EasyDashLoggerConfig.configure(
    showLogsInDebug: true,
    useColors: false,
    output: (message, name) {
      // send to a file, Crashlytics, a test spy, ...
    },
  );
  'This goes to the custom sink'.printLog();
}
