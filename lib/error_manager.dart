import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory?> getDownloadDir() async {
  if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isMacOS ||
      Platform.isWindows) {
    return await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
  }
  // Web or unsupported platform
  return null;
}

class ErrorManager {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  static String generateMessage({
    required String errorMessage,
    String? originFunction,
    String? fileName,
    String? developer,
    StackTrace? stackTrace,
  }) {
    String logMessage = errorMessage;

    final file =
        fileName != null && fileName.isNotEmpty ? '\nFile: $fileName' : null;
    if (file != null) {
      logMessage = logMessage + file;
    }

    final function = originFunction != null && originFunction.isNotEmpty
        ? '\nFunction: $originFunction'
        : null;

    if (function != null) {
      logMessage = logMessage + function;
    }

    final developerName = developer == null ? null : '\nDeveloper: $developer';
    if (developerName != null) {
      logMessage = logMessage + developerName;
    }

    final stacktrace =
        '\nStack Trace: ${stackTrace ?? 'No stack trace available'}';

    logMessage = logMessage + stacktrace;

    return logMessage;
  }

  static void logError({
    required String errorMessage,
    LogType logType = LogType.error,
    String? originFunction,
    String? fileName,
    String? developer,
    StackTrace? stackTrace,
  }) {
    // Check multiple ways to detect if we're running tests
    final isRunningTests = const bool.fromEnvironment('FLUTTER_TEST',
            defaultValue: false) ||
        const bool.fromEnvironment('dart.library.test', defaultValue: false) ||
        _isInTestEnvironment();

    // Only log in debug mode AND when not running tests
    if (kDebugMode && !isRunningTests) {
      String logMessage = generateMessage(
        errorMessage: errorMessage,
        fileName: fileName,
        originFunction: originFunction,
        developer: developer,
        stackTrace: stackTrace,
      );

      //lineNumber: details.stackTrace?.lineNumber ?? 0,
      switch (logType) {
        case LogType.debug:
          _logger.d(logMessage);
          break;
        case LogType.error:
          _logger.e(logMessage);
          break;
        case LogType.fatal:
          _logger.f(logMessage);
          break;
        case LogType.info:
          _logger.i(logMessage);
          break;
        case LogType.trace:
          _logger.t(logMessage);
          break;
        case LogType.warning:
          _logger.w(logMessage);
          break;
      }
    }
  }

  static Future<void> logToFile({
    required String errorMessage,
    LogType logType = LogType.error,
    String? originFunction,
    String? fileName,
    String? logFileName,
    String? developer,
    StackTrace? stackTrace,
  }) async {
    // Check if we're running tests
    final isRunningTests = const bool.fromEnvironment('FLUTTER_TEST',
            defaultValue: false) ||
        const bool.fromEnvironment('dart.library.test', defaultValue: false) ||
        _isInTestEnvironment();

    // Only log when not running tests
    if (!isRunningTests) {
      try {
        String logMessage = generateMessage(
          errorMessage: errorMessage,
          fileName: fileName,
          originFunction: originFunction,
          developer: developer,
          stackTrace: stackTrace,
        );

        final directory = await getDownloadDir();
        if (directory == null) {
          if (kDebugMode) {
            _logger.e('Download directory is not available.');
          }
          return;
        }
        final logDirectory = Directory('${directory.path}/error_manager');

        // Create directory if it doesn't exist
        if (!await logDirectory.exists()) {
          await logDirectory.create(recursive: true);
        }

        // Use logFileName if provided, otherwise default name
        final filename = logFileName ??
            'error_log_${DateTime.now().toIso8601String().replaceAll(':', '-')}.txt';
        final file = File('${logDirectory.path}/$filename');

        // Write to file
        await file.writeAsString('$logMessage\n', mode: FileMode.append);

        // Log success in debug mode
        if (kDebugMode) {
          _logger.i('Error logged to: ${file.path}');
        }
      } catch (e, stack) {
        if (kDebugMode) {
          _logger.e('Failed to log error to file', error: e, stackTrace: stack);
        }
      }
    }
  }

  /// Helper method to detect if we're in a test environment
  /// by checking the call stack for test-related frames
  static bool _isInTestEnvironment() {
    try {
      final stackTrace = StackTrace.current.toString();
      return stackTrace.contains('package:test/') ||
          stackTrace.contains('package:flutter_test/') ||
          stackTrace.contains('_test.dart') ||
          stackTrace.contains('/test/');
    } catch (e) {
      return false;
    }
  }
}

enum LogType { debug, error, fatal, info, trace, warning }
