import 'package:go_router/go_router.dart';
import 'package:ff_desktop/features/features.dart';

final appRouter = GoRouter(
  initialLocation: HomePage.routePath,
  routes: [
    GoRoute(
      name: HomePage.routeName,
      path: HomePage.routePath,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
