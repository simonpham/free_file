import 'package:core/core.dart';
import 'package:ff_desktop/app.dart';
import 'package:flutter/material.dart';
import 'package:local_entity_provider/local_entity_provider.dart';

Future<void> main() async {
  final EntityProvider entityProvider = LocalEntityProvider();
  runApp(
    const FreeFile(),
  );
}
