import 'package:core/core.dart';
import 'package:ff_desktop/app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_entity_provider/local_entity_provider.dart';
import 'package:ff_desktop/features/home/ui/ui.dart';

Future<void> main() async {
  final EntityProvider entityProvider = LocalEntityProvider();
  final entities = await entityProvider.list(Uri(path: '/'));
  for (final entity in entities) {
    debugPrint(entity.path.path);
  }
  runApp(
    const FreeFile(),
  );
}

final router = GoRouter(
  initialLocation: HomePage.routePath,
  routes: [
    GoRoute(
      name: HomePage.routeName,
      path: HomePage.routePath,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
