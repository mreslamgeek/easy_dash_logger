
# Easy Dash Logger

Easy Dash Logger is a versatile logging package for Dart and Flutter applications. It provides platform-specific logging capabilities, ensuring that your logs are handled appropriately whether you're running in a Flutter environment or a Dart console application. It supports customizable colored log output to enhance readability.

## Features

- Platform-specific logging for Flutter and Dart environments.
- ANSI color support for terminal output, customizable by message and background colors.
- Easy-to-use API for logging messages with different severity levels.
- Automatically detects the environment and switches between `developer.log` in debug mode and `print` in release mode.

## Getting Started

### Prerequisites

Make sure you have the following tools installed:

- **Dart SDK**: >=2.12.0 <3.0.0
- **Flutter SDK** (optional): If you're using this package in a Flutter project.

### Installation

To install **Easy Dash Logger**, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  easy_dash_logger: latest_version
```

Then run the following command to fetch the package:

```bash
flutter pub get
# or for Dart projects:
dart pub get
```

## Usage

### Importing the Package

To use **Easy Dash Logger**, you need to import the package into your project:

```dart
import 'package:easy_dash_logger/easy_dash_logger.dart';
```

### Logging Messages with Color Customization

The new logging API allows you to print log messages with customizable foreground and background colors using the `printLog` extension. Here's an example of how you can use this functionality:

```dart
void main() {
  'This is a debug message'.printLog(); // Default yellow foreground

  'This is a warning message'.printLog(
    name: 'WARNING',
    color: ANSICOLOR.red,
    bgColor: ANSICOLOR.yellow, // Background color
  );

  'This is an error message with a blue background'.printLog(
    name: 'ERROR',
    color: ANSICOLOR.white,
    bgColor: ANSICOLOR.blue,
  );
}
```

### Conditional Logging (Debug vs Release Mode)

**Easy Dash Logger** automatically detects the current environment (debug or release) and uses the appropriate logging method:

- In **debug mode**, it uses `developer.log`, which integrates well with IDE consoles and debuggers.
- In **release mode**, it falls back to `print` to keep the logging simple and lightweight.

This behavior is handled automatically by the `printLog` method.

### ANSI Color Support

For terminal output, **Easy Dash Logger** supports ANSI color codes. You can easily customize the foreground and background colors using the `ANSICOLOR` enum. Available colors include:

- **Foreground**: `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`, and more.
- **Background**: You can also set the background color using the `bgColor` argument.

Example:

```dart
'This is a green message with a red background'.printLog(
  color: ANSICOLOR.green,
  bgColor: ANSICOLOR.red,
);
```

### Advanced Example

Here's an advanced example showing how to log messages with customized color schemes and in different modes:

```dart
void main() {
  // Default logging
  'Starting application...'.printLog();

  // Warning message with a custom name and colors
  'Memory usage is high'.printLog(
    name: 'MEMORY_WARNING',
    color: ANSICOLOR.yellow,
    bgColor: ANSICOLOR.blue,
  );

  // Error message
  'Application crashed due to unhandled exception'.printLog(
    name: 'CRASH',
    color: ANSICOLOR.red,
    bgColor: ANSICOLOR.white,
  );
}
```

## Additional Information

For more details on how to use the package and customize the logs further, refer to the [API documentation](https://pub.dev/documentation/easy_dash_logger/latest/).

## Contributing

We welcome contributions to improve **Easy Dash Logger**. If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/new-feature`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a pull request.

Feel free to open issues for any bugs or feature requests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
