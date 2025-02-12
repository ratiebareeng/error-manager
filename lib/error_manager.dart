import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';

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
        fileName == null || fileName.isEmpty ? null : '\nFile: $fileName';
    if (file != null) {
      logMessage = logMessage + file;
    }

    final function = originFunction == null || originFunction.isEmpty
        ? null
        : 'Function: $fileName';
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
    String logMessage = generateMessage(
      errorMessage: errorMessage,
      fileName: fileName,
      originFunction: originFunction,
      developer: developer,
      stackTrace: stackTrace,
    );

    // Log to console in debug
    if (kDebugMode) {
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
    String logMessage = generateMessage(
      errorMessage: errorMessage,
      fileName: fileName,
      originFunction: originFunction,
      developer: developer,
      stackTrace: stackTrace,
    );

    var directory = await getDownloadsDirectory();
    directory ??= await getApplicationDocumentsDirectory();
    var filename =
        fileName ?? 'error_log${DateTime.now().toIso8601String()}.txt';
    final file = File('${directory.path}/error_manager/$filename');
    await file.writeAsString('$logMessage\n', mode: FileMode.append);
  }
}

enum LogType { debug, error, fatal, info, trace, warning }
