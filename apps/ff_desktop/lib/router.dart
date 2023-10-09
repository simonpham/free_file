import 'package:ff_desktop/ui/ui.dart';
import 'package:go_router/go_router.dart';
import 'package:ff_desktop/features/features.dart';

final appRouter = GoRouter(
  initialLocation: MainPage.routePath,
  routes: [
    GoRoute(
      path: MainPage.routePath,
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      name: HomePage.routeName,
      path: HomePage.routePath,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
