import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../core/theme/hypr_tokens.dart';
import 'router.dart';

/// Root Flutter application wiring `GoRouter`, `M3ETheme`, and `HyprTokens`.
class ChomskyApp extends StatefulWidget {
  const ChomskyApp({super.key, this.initialLocation = '/'});

  final String initialLocation;

  @override
  State<ChomskyApp> createState() => _ChomskyAppState();
}

class _ChomskyAppState extends State<ChomskyApp> {
  late final _router = createAppRouter(initialLocation: widget.initialLocation);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m3eData = buildDefaultM3ETheme();
    final materialTheme = buildRootMaterialTheme(m3eData);

    return MaterialApp.router(
      title: 'Chomsky — Embedded, Linux & Interactive Apps',
      debugShowCheckedModeBanner: false,
      theme: materialTheme,
      darkTheme: materialTheme,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
      builder: (context, child) {
        return M3ETheme(
          data: m3eData,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
