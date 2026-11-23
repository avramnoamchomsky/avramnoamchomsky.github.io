import 'package:material_ui/material_ui.dart';

import '../../core/widgets/hypr_background.dart';
import 'widgets/focus_and_stack_section.dart';
import 'widgets/hypr_hero.dart';
import 'widgets/hypr_navbar.dart';
import 'widgets/sub_apps_section.dart';

/// Hyprland-inspired landing page serving as the hub for M3E sub-apps.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _appsKey = GlobalKey();
  final GlobalKey _focusKey = GlobalKey();
  final GlobalKey _stackKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    Scrollable.ensureVisible(
      target,
      duration: disableMotion
          ? Duration.zero
          : const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    final disableMotion = MediaQuery.disableAnimationsOf(context);
    if (disableMotion) {
      _scrollController.jumpTo(0);
    } else {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HyprBackground(
        child: SelectionArea(
          child: Stack(
            children: [
              Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 118, 20, 40),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1180),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          HyprHero(
                            onExploreApps: () => _scrollToSection(_appsKey),
                          ),
                          const SizedBox(height: 92),
                          KeyedSubtree(
                            key: _appsKey,
                            child: const SubAppsSection(),
                          ),
                          const SizedBox(height: 88),
                          KeyedSubtree(
                            key: _focusKey,
                            child: const FocusSection(),
                          ),
                          const SizedBox(height: 88),
                          KeyedSubtree(
                            key: _stackKey,
                            child: const StackAndFooterSection(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: HyprNavbar(
                    onJumpToTop: _scrollToTop,
                    onJumpToApps: () => _scrollToSection(_appsKey),
                    onJumpToFocus: () => _scrollToSection(_focusKey),
                    onJumpToStack: () => _scrollToSection(_stackKey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
