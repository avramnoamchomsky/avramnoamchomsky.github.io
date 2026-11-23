import 'package:go_router/go_router.dart';

import '../features/home/home_page.dart';
import '../features/snake/snake_page.dart';

/// Builds the application [GoRouter] mapping `/` to the homepage and
/// `/apps/snake` to the Material 3 Expressive Snake sub-app.
GoRouter createAppRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/apps/snake',
        name: 'snake',
        builder: (context, state) => const SnakeAppPage(),
      ),
    ],
    errorBuilder: (context, state) => const HomePage(),
  );
}
