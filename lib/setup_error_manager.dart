import 'dart:ui';

import 'package:error_manager/error_manager.dart';
import 'package:error_manager/error_page.dart';
import 'package:flutter/material.dart';

void setupErrorManager() {
  // Replace default error screen
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return SimpleErrorPage(
      errorMessage: details.exceptionAsString(),
      stackTrace: details.stack,
    );
  };

  // Log Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) async {
    await ErrorManager.logToFile(
      fileName: details.stack?.toString() ?? 'Unknown',
      errorMessage: details.exceptionAsString(),
      stackTrace: details.stack,
    );
  };

  // Log uncaught platform errors
  PlatformDispatcher.instance.onError = (error, stack) async {
    await ErrorManager.logToFile(
      fileName: stack.toString(),
      errorMessage: error.toString(),
      stackTrace: stack,
    );
    return true;
  } as ErrorCallback?;
}
