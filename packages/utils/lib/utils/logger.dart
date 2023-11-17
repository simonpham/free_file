import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

void printLog(dynamic message) {
  if (!kDebugMode) {
    return;
  }

  dev.log(
    message.toString(),
    name: 'Free File',
    time: DateTime.now(),
  );
}

void printError(dynamic err, dynamic trace) {
  if (!kDebugMode) {
    return;
  }

  dev.log(
    err.toString(),
    name: 'Free File',
    time: DateTime.now(),
    error: err,
    stackTrace: trace,
  );
}
