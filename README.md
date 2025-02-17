# Flutter Error Manager

A simple error management solution for Flutter applications. Suitable to quickly setup error logging that includes file-based logging, and customizable error pages.

## Features

- 🚨 Automatic error capturing and logging
- 📝 File-based error logging with customizable file names
- 🎨 Two built-in error page designs (Modern and Simple)
- 🔄 Retry functionality support
- 📱 Cross-platform support
- 🎯 Debug mode console logging
- 🔍 Detailed stack trace handling
- 👨‍💻 Developer attribution for errors

## Requirements

- Flutter: >=3.0.0
- Dart: >=3.0.0

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  error_manager: 
    git:
      url: https://github.com/ratiebareeng/error-manager.git
      ref: main
```

## Getting Started

1. Initialize the error manager in your `main.dart`:

```dart
void main() {
  setupErrorManager();
  runApp(MyApp());
}
```

2. Use the error manager to log errors:

```dart
// Log an error to console (debug mode)
ErrorManager.logError(
  errorMessage: 'Something went wrong!',
  originFunction: 'myFunction',
  fileName: 'my_file.dart',
  developer: 'Naledi',
);

// Log an error to file
await ErrorManager.logToFile(
  errorMessage: 'Critical error occurred',
  developer: 'Keletso',
);
```

## Error Pages

### Error Page

A Material Design 3 compliant error page with expandable stack trace and retry functionality:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ErrorPage(
      errorMessage: 'Failed to load data',
      stackTrace: stackTrace,
      onRetry: () => loadData(),
    ),
  ),
);
```

### Simple Error Page

A basic error page for quick implementation:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SimpleErrorPage(
      errorMessage: 'Network connection failed',
      stackTrace: stackTrace,
    ),
  ),
);
```

## Advanced Usage

### Custom Log Types

The package supports different log types:

```dart
ErrorManager.logError(
  errorMessage: 'Debug information',
  logType: LogType.debug,  // Available: debug, error, fatal, info, trace, warning
);
```

### Custom Log File Names

Specify custom file names for your logs:

```dart
await ErrorManager.logToFile(
  errorMessage: 'Database error',
  logFileName: 'database_errors.txt',
);
```

### Global Error Handling

The `setupErrorManager` function automatically handles:
- Flutter framework errors
- Platform errors
- Widget errors

## Directory Structure

Logged errors are stored in:
- Android: `[External Storage]/Downloads/error_manager/`
- iOS: `[App Documents Directory]/error_manager/`

## Error Message Format

Error logs include:
- Error message
- File name (optional)
- Function name (optional)
- Developer name (optional)
- Stack trace
- Timestamp (for file logs)

## Additional Information

For bugs or feature requests, please create an issue on the [GitHub repository](https://github.com/ratiebareeng/error-manager).

## License

This project is licensed under the MIT License - see the LICENSE file for details.
