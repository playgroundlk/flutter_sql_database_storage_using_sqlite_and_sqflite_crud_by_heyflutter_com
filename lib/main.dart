import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  // // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;
  runApp(
    const App(),
  );
}
