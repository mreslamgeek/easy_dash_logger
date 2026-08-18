## [2.0.0] - 2026-08-18
### Breaking
- **Logging is now disabled by default in release and profile builds** and
  enabled in debug builds. Nothing from a shipped app reaches a log sink unless
  you opt in with `EasyDashLoggerConfig.configure(showLogsInRelease: true)`.
  No call site changes are required — `printLog`'s signature is unchanged.

### Added
- `EasyDashLoggerConfig` — configure logging before the app starts. Visibility
  is set per build mode with `showLogsInDebug`, `showLogsInProfile`, and
  `showLogsInRelease`; `isLoggingEnabled` reports the resolved value for the
  running build. Also configurable: `defaultName`, `defaultColor`,
  `defaultBgColor`, `useColors`, and a custom `output` sink.
- `EasyDashLoggerConfig.silenceAll()` to mute every build mode at runtime, and
  `reset()` to restore the defaults.
- Build-mode constants: `kLoggerDebugMode`, `kLoggerReleaseMode`,
  `kLoggerProfileMode`, `kLoggerIsWeb`. They resolve identically to Flutter's
  `kDebugMode`, `kReleaseMode`, `kProfileMode`, and `kIsWeb`.
- Compile-time kill switch `--dart-define=EASY_DASH_LOGGER_DISABLED=true`, which
  lets the AOT compiler strip the logging code and the message literals from the
  binary.

### Changed
- `printLog` returns before building any string when logging is disabled, so
  disabled call sites cost nothing.
- Web now logs through `print()`; `dart:developer`'s `log()` is an empty stub
  when compiled to JavaScript/Wasm, so web logs previously went nowhere.
- ANSI colors are off by default on the web, where the console renders escape
  codes as literal text.
- The `print()` sink now prefixes the message with the log name, matching what
  `developer.log` shows.
- `printLog`'s `name`, `color`, and `bgColor` parameters are now nullable and
  fall back to the configured defaults.
- **The package no longer depends on the Flutter SDK.** Dart-only projects can
  now install it with `dart pub get`; Flutter projects are unaffected and still
  get the `dart:developer` sink automatically. `uses-material-design` was
  dropped too, so consuming apps no longer pull the Material icon font on this
  package's behalf.

### Fixed
- Documentation no longer claims the sink is chosen by build mode; it is chosen
  by platform (Flutter vs. web vs. plain Dart).
- README no longer lists a `magenta` color that does not exist, and the stated
  SDK constraints now match `pubspec.yaml`.

### Migration
- No code changes are required. See "Upgrading from 1.x to 2.0" in the README if
  you relied on logs appearing in release or profile builds.

## [1.0.2] - 2025-02-16
### Updated
- Package Version.
## [1.0.1] - 2024-09-23
### Added
- Support older dart versions.
## [1.0.0] - 2024-09-18
### Added
- Platform-specific logging for Flutter and Dart environments.
- `printLog` extension method for customizable colored log output.
- ANSI color support for terminal output.

### Changed
- Updated documentation to reflect new features.

## [0.0.2] - 2024-09-17
### Changed
- Updated version to 0.0.2.

## [0.0.1] - 2024-09-16
### Added
- Initial release of Easy Dash Logger.