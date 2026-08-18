part of '../easy_dash_logger.dart';

/// True when the app was compiled in release mode
/// (`--release` / `-Ddart.vm.product=true`).
const bool kLoggerReleaseMode = bool.fromEnvironment('dart.vm.product');

/// True when the app was compiled in profile mode
/// (`--profile` / `-Ddart.vm.profile=true`).
const bool kLoggerProfileMode = bool.fromEnvironment('dart.vm.profile');

/// True only in debug builds.
///
/// Mirrors Flutter's `kDebugMode` without depending on `package:flutter`, so
/// the package keeps working in plain Dart projects.
const bool kLoggerDebugMode = !kLoggerReleaseMode && !kLoggerProfileMode;

/// True when running on the web (dart2js or dart2wasm).
///
/// On the web `dart:developer`'s `log()` is an empty stub, so logging has to
/// fall back to `print()` to reach the browser console.
const bool kLoggerIsWeb = bool.fromEnvironment('dart.library.js_interop') ||
    bool.fromEnvironment('dart.library.html');

/// Compile-time kill switch.
///
/// Build with `--dart-define=EASY_DASH_LOGGER_DISABLED=true` to make
/// [EasyDashLoggerConfig.isLoggingEnabled] a compile-time `false`, which lets
/// the AOT compiler drop the logging code and the message literals from the
/// binary. It cannot be turned back on at runtime.
const bool kLoggerForceDisabled =
    bool.fromEnvironment('EASY_DASH_LOGGER_DISABLED');

/// Signature of a custom log sink. See [EasyDashLoggerConfig.output].
typedef LogOutput = void Function(String message, String name);

/// Global configuration for [ColoredLog.printLog].
///
/// Log visibility is controlled per build mode. Out of the box logs appear in
/// **debug builds only** — profile and release builds stay silent, so nothing
/// leaks from a shipped app.
///
/// Change it before the app starts — typically the first line of `main()`:
///
/// ```dart
/// void main() {
///   EasyDashLoggerConfig.configure(showLogsInRelease: true);
///   runApp(const MyApp());
/// }
/// ```
class EasyDashLoggerConfig {
  EasyDashLoggerConfig._();

  /// Whether logs are shown in debug builds. Defaults to `true`.
  static bool showLogsInDebug = true;

  /// Whether logs are shown in profile builds (`flutter run --profile`).
  ///
  /// Defaults to `false`. Profile builds still run a VM service, so anything
  /// logged here is readable in DevTools by whoever holds the build.
  static bool showLogsInProfile = false;

  /// Whether logs are shown in release builds (`flutter build` / `--release`).
  ///
  /// Defaults to `false`. Set it to `true` only when you deliberately want
  /// logging in a shipped app — for example behind a QA or support switch.
  static bool showLogsInRelease = false;

  /// Whether logging is on for the build that is currently running.
  ///
  /// Resolves [showLogsInDebug], [showLogsInProfile], and [showLogsInRelease]
  /// against the current build mode. Always `false` when the app was built with
  /// `--dart-define=EASY_DASH_LOGGER_DISABLED=true`.
  static bool get isLoggingEnabled {
    if (kLoggerForceDisabled) return false;
    if (kLoggerReleaseMode) return showLogsInRelease;
    if (kLoggerProfileMode) return showLogsInProfile;
    return showLogsInDebug;
  }

  /// Name used when a call site does not pass one.
  static String defaultName = 'DEBUG_LOG';

  /// Foreground color used when a call site does not pass one.
  static ANSICOLOR defaultColor = ANSICOLOR.yellow;

  /// Background color used when a call site does not pass one.
  static ANSICOLOR? defaultBgColor;

  /// Whether ANSI escape codes are added to the message.
  ///
  /// Defaults to `false` on the web, where the browser console renders the
  /// escape codes as literal text instead of colors.
  static bool useColors = !kLoggerIsWeb;

  /// Optional sink that replaces the built-in one.
  ///
  /// When set, it receives every message instead of `dart:developer`'s `log()`
  /// / `print()` — useful for routing logs to a file, Crashlytics, or a test
  /// spy. It is still subject to [isLoggingEnabled].
  static LogOutput? output;

  /// Applies the given settings. Every argument is optional; omitted ones keep
  /// their current value.
  ///
  /// Call this before the first log — usually at the top of `main()`.
  static void configure({
    bool? showLogsInDebug,
    bool? showLogsInProfile,
    bool? showLogsInRelease,
    String? defaultName,
    ANSICOLOR? defaultColor,
    ANSICOLOR? defaultBgColor,
    bool? useColors,
    LogOutput? output,
  }) {
    if (showLogsInDebug != null) {
      EasyDashLoggerConfig.showLogsInDebug = showLogsInDebug;
    }
    if (showLogsInProfile != null) {
      EasyDashLoggerConfig.showLogsInProfile = showLogsInProfile;
    }
    if (showLogsInRelease != null) {
      EasyDashLoggerConfig.showLogsInRelease = showLogsInRelease;
    }
    if (defaultName != null) EasyDashLoggerConfig.defaultName = defaultName;
    if (defaultColor != null) EasyDashLoggerConfig.defaultColor = defaultColor;
    if (defaultBgColor != null) {
      EasyDashLoggerConfig.defaultBgColor = defaultBgColor;
    }
    if (useColors != null) EasyDashLoggerConfig.useColors = useColors;
    if (output != null) EasyDashLoggerConfig.output = output;
  }

  /// Turns logging off in every build mode, including debug.
  ///
  /// Handy for a runtime "mute logs" switch. Other settings are untouched.
  static void silenceAll() {
    showLogsInDebug = false;
    showLogsInProfile = false;
    showLogsInRelease = false;
  }

  /// Restores every setting to its default, including clearing
  /// [defaultBgColor] and [output].
  static void reset() {
    showLogsInDebug = true;
    showLogsInProfile = false;
    showLogsInRelease = false;
    defaultName = 'DEBUG_LOG';
    defaultColor = ANSICOLOR.yellow;
    defaultBgColor = null;
    useColors = !kLoggerIsWeb;
    output = null;
  }
}
