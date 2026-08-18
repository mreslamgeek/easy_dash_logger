# Easy Dash Logger

[![pub package](https://img.shields.io/pub/v/easy_dash_logger.svg)](https://pub.dev/packages/easy_dash_logger)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Colored, named logging for Dart and Flutter — with a safe default: **your logs do not appear in release builds unless you say so.**

```dart
'Server responded in 42ms'.printLog(name: 'API', color: ANSICOLOR.green);
```

## Features

- One-line logging on any object via the `printLog` extension.
- **Silent in release and profile builds by default** — opt in per build mode with `showLogsInRelease` / `showLogsInProfile`.
- Zero cost when off: disabled call sites build no string at all.
- ANSI colors for foreground and background, customizable per message or globally.
- The right sink per platform, chosen automatically: `developer.log` on Flutter, `print` on plain Dart and on the web.
- Pluggable `output` sink to route logs to a file, a crash reporter, or a test spy.
- A compile-time kill switch that strips log code *and* message strings from the binary.
- **No Flutter dependency** — works in Flutter apps, Dart CLIs, servers, and the web.

## Getting Started

### Prerequisites

- **Dart SDK**: `>=2.17.0 <4.0.0`
- **Flutter SDK** (optional): only if you are using the package in a Flutter project. The package itself does not depend on Flutter.

### Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  easy_dash_logger: ^2.0.0
```

Then fetch it:

```bash
flutter pub get
# or, in a Dart project:
dart pub get
```

### Quick Start

```dart
import 'package:easy_dash_logger/easy_dash_logger.dart';

void main() {
  // Optional — the defaults are already release-safe.
  EasyDashLoggerConfig.configure(defaultName: 'MY_APP');

  runApp(const MyApp());
}

// Anywhere in your code:
'User signed in'.printLog();
'Cache miss'.printLog(name: 'CACHE', color: ANSICOLOR.orange);
```

Logs appear while you develop and disappear when you ship. Nothing else to remember.

## Usage

### Logging messages with color customization

`printLog` is an extension on `Object?`, so it works on anything — strings, maps, models, exceptions:

```dart
void main() {
  'This is a debug message'.printLog(); // Default yellow foreground

  'This is a warning message'.printLog(
    name: 'WARNING',
    color: ANSICOLOR.red,
    bgColor: ANSICOLOR.yellow, // Background color
  );

  {'user': 1, 'plan': 'pro'}.printLog(name: 'STATE');
}
```

| Parameter | Type | Default |
|---|---|---|
| `name` | `String?` | `EasyDashLoggerConfig.defaultName` (`'DEBUG_LOG'`) |
| `color` | `ANSICOLOR?` | `EasyDashLoggerConfig.defaultColor` (`ANSICOLOR.yellow`) |
| `bgColor` | `ANSICOLOR?` | `EasyDashLoggerConfig.defaultBgColor` (none) |

### Release safety and configuration

Logs are shown in **debug builds only** by default. Profile and release builds stay silent, so nothing leaks from a shipped app unless you ask for it.

Each build mode has its own flag, so the intent is readable at the call site. Configure **before the app starts** — the first line of `main()`:

```dart
void main() {
  EasyDashLoggerConfig.configure(
    showLogsInRelease: true, // logs in a shipped app too
  );
  runApp(const MyApp());
}
```

| Setting | Default | Purpose |
|---|---|---|
| `showLogsInDebug` | `true` | Logs during development. |
| `showLogsInProfile` | `false` | Profile builds still run a VM service, so logs there are readable in DevTools by whoever holds the build. |
| `showLogsInRelease` | `false` | Logs in a shipped app — turn on deliberately, e.g. behind a QA or support switch. |
| `defaultName` | `'DEBUG_LOG'` | Name used when a call site omits `name`. |
| `defaultColor` | `ANSICOLOR.yellow` | Foreground used when a call site omits `color`. |
| `defaultBgColor` | `null` | Background used when a call site omits `bgColor`. |
| `useColors` | `false` on web, `true` elsewhere | Whether ANSI escape codes are added. |
| `output` | `null` | Custom sink `(String message, String name)` — route logs to a file, Crashlytics, or a test spy. |

Every `configure` argument is optional; omitted settings keep their current value.

```dart
// Read-only: whether logging is on for the build that is running now
EasyDashLoggerConfig.isLoggingEnabled;

// Mute everything at runtime, in every build mode
EasyDashLoggerConfig.silenceAll();

// Restore every default, including clearing `output` and `defaultBgColor`
EasyDashLoggerConfig.reset();
```

> **Note:** only the flag matching the build mode you are *running* has any effect. Setting `showLogsInRelease: true` during a debug session changes nothing there — it takes effect when that same code runs in a release build.

Build-mode constants are exported if you need your own conditions:

```dart
kLoggerDebugMode    // true only in debug builds
kLoggerReleaseMode  // true in --release builds
kLoggerProfileMode  // true in --profile builds
kLoggerIsWeb        // true on dart2js / dart2wasm
```

### Routing logs somewhere else

Set `output` to take over the sink entirely — it still respects the build-mode flags:

```dart
EasyDashLoggerConfig.configure(
  useColors: false, // ANSI codes are noise in a file or a crash report
  output: (message, name) {
    FirebaseCrashlytics.instance.log('[$name] $message');
  },
);
```

In tests, the same hook makes log output assertable:

```dart
final captured = <String>[];
EasyDashLoggerConfig.configure(
  useColors: false,
  output: (message, name) => captured.add('$name|$message'),
);

'hello'.printLog(name: 'SINK');
expect(captured.single, 'SINK|hello');
```

Call `EasyDashLoggerConfig.reset()` in `tearDown` to clear it.

### Stripping logs from the binary entirely

These are runtime flags, so the log call sites and their message strings still exist in a release binary even while `showLogsInRelease` is `false` — they simply produce no output. If you want them gone from the compiled app, build with the compile-time kill switch:

```bash
flutter build apk --dart-define=EASY_DASH_LOGGER_DISABLED=true
```

That makes `EasyDashLoggerConfig.isLoggingEnabled` a compile-time `false`, which lets the AOT compiler drop the logging code **and** the message literals. It cannot be turned back on at runtime.

### Where the logs go

The sink is chosen by platform, not by build mode:

| Target | Sink |
|---|---|
| Flutter (mobile / desktop) | `dart:developer`'s `log()` — shows in the IDE console and DevTools |
| Flutter Web | `print()` — `dart:developer`'s `log()` is a no-op on the web |
| Plain Dart | `print()` |
| Any target with `output` configured | Your custom sink |

## ANSI Color Support

Colors come from the `ANSICOLOR` enum, applied to the foreground (`color`) and the background (`bgColor`):

```dart
'This is a green message with a red background'.printLog(
  color: ANSICOLOR.green,
  bgColor: ANSICOLOR.red,
);
```

Available values:

| Group | Values |
|---|---|
| Basic | `black`, `white`, `red`, `green`, `yellow`, `blue`, `cyan`, `purple` |
| Extended | `orange`, `pink`, `lightBlue`, `lightGreen`, `lightRed`, `lightYellow` |
| Bright | `brightRed`, `brightGreen`, `brightCyan`, `brightMagenta` |

`ANSICOLOR.reset` is used internally to close each sequence, including on multi-line messages, where every line is re-colored so wrapped output stays readable.

Colors are disabled automatically on the web, where consoles render escape codes as literal text. Turn them off anywhere else with `EasyDashLoggerConfig.configure(useColors: false)`.

## Advanced Example

```dart
void main() {
  EasyDashLoggerConfig.configure(
    defaultName: 'APP',
    defaultColor: ANSICOLOR.lightBlue,
    showLogsInProfile: true, // keep logs while profiling
  );

  'Starting application...'.printLog();

  'Memory usage is high'.printLog(
    name: 'MEMORY_WARNING',
    color: ANSICOLOR.yellow,
    bgColor: ANSICOLOR.blue,
  );

  'Application crashed due to unhandled exception'.printLog(
    name: 'CRASH',
    color: ANSICOLOR.red,
    bgColor: ANSICOLOR.white,
  );
}
```

## Upgrading from 1.x to 2.0

**No code changes are required** — `printLog` call sites compile unchanged. The major
version signals one deliberate behavior change:

- Logs no longer appear in **release or profile** builds. If you relied on that, add `EasyDashLoggerConfig.configure(showLogsInRelease: true)` at the top of `main()`.
- Flutter Web now logs through `print()`. Previously nothing reached the browser console, because `dart:developer`'s `log()` is an empty stub when compiled to JavaScript or Wasm.
- The `print()` sink now prefixes the log name, matching what `developer.log` displays: `[NAME] message`.
- `printLog`'s `name`, `color`, and `bgColor` parameters are now nullable and fall back to the configured defaults. Existing call sites compile unchanged.
- The package no longer depends on the Flutter SDK, so Dart-only projects can finally install it. Flutter projects are unaffected — the Flutter log sink is still selected automatically when `dart:ui` is available.

If your call sites are already wrapped in `if (kDebugMode)`, you can drop the wrapper — the package now handles it, and the guard is no longer needed for release safety. Keep it only where you also want the message literals kept out of the binary, or use the `--dart-define` kill switch instead.

## Additional Information

For the full API surface, see the [API documentation](https://pub.dev/documentation/easy_dash_logger/latest/).

## Contributing

Contributions are welcome:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/new-feature`).
3. Run `dart analyze` and `dart test`.
4. Commit your changes (`git commit -m 'Add new feature'`).
5. Push to the branch (`git push origin feature/new-feature`).
6. Open a pull request.

Feel free to open [issues](https://github.com/mreslamgeek/easy_dash_logger/issues) for any bugs or feature requests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
