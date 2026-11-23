import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/hypr_tokens.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/widgets/hypr_window_frame.dart';
import '../../../data/site_data.dart';

/// Hyprland-inspired Hero with bold gradient typography and a live tiling
/// workspace showcase previewing the Snake sub-app.
class HyprHero extends StatelessWidget {
  const HyprHero({
    super.key,
    required this.onExploreApps,
  });

  final VoidCallback onExploreApps;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<HyprTokens>() ?? HyprTokens.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 11,
                child: _HeroCopy(
                  tokens: tokens,
                  onExploreApps: onExploreApps,
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                flex: 10,
                child: _HyprTilingShowcase(tokens: tokens),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeroCopy(
              tokens: tokens,
              onExploreApps: onExploreApps,
            ),
            const SizedBox(height: 36),
            _HyprTilingShowcase(tokens: tokens),
          ],
        );
      },
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.tokens,
    required this.onExploreApps,
  });

  final HyprTokens tokens;
  final VoidCallback onExploreApps;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final headlineSize = width >= 960 ? 58.0 : (width >= 600 ? 46.0 : 36.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live status pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: const Color(0x1433CCFF),
            border: Border.all(color: tokens.cyan.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tokens.mint,
                  boxShadow: [
                    BoxShadow(
                      color: tokens.mint.withValues(alpha: 0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'NixOS • Embedded • Cross-Platform Flutter',
                  style: tokens.monoStyle(
                    fontSize: 12,
                    color: tokens.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        ShaderMask(
          shaderCallback: (bounds) => tokens.headlineGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            'Low-level craft,\nexpressive pixels.',
            style: TextStyle(
              fontSize: headlineSize,
              height: 1.02,
              letterSpacing: -1.8,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
        const SizedBox(height: 20),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            "I'm Chomsky. I explore embedded systems, Linux, NixOS, and "
            "what happens beneath the abstractions — now building a personal "
            "web & multi-platform workspace with Flutter and Material 3 Expressive.",
            style: TextStyle(
              color: tokens.textSecondary,
              fontSize: 16.5,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 28),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            M3EButton.filled(
              onPressed: () => context.go('/apps/snake'),
              size: M3EButtonSize.md,
              shape: M3EButtonShape.round,
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Text('Launch M3E Snake'),
              decoration: M3EButtonDecoration(
                backgroundGradient: WidgetStateProperty.all(
                  LinearGradient(colors: [tokens.cyan, tokens.mint]),
                ),
                foregroundColor: WidgetStateProperty.all(
                  const Color(0xFF041013),
                ),
              ),
            ),
            M3EButton.outlined(
              onPressed: onExploreApps,
              size: M3EButtonSize.md,
              shape: M3EButtonShape.round,
              icon: Icon(
                Icons.grid_view_rounded,
                size: 18,
                color: tokens.cyan,
              ),
              label: Text(
                'Browse Sub-Apps',
                style: TextStyle(color: tokens.textPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),

        _QuickCommandBar(tokens: tokens),
      ],
    );
  }
}

class _QuickCommandBar extends StatelessWidget {
  const _QuickCommandBar({required this.tokens});

  final HyprTokens tokens;
  static const String _cmd = 'git clone ${SiteData.siteRepoUrl}.git';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x99090E17),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tokens.borderIdle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '❯',
            style: tokens.monoStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: tokens.mint,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              _cmd,
              overflow: TextOverflow.ellipsis,
              style: tokens.monoStyle(
                fontSize: 12.5,
                color: tokens.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          M3EIconButton(
            icon: Icon(Icons.copy_rounded, size: 16, color: tokens.cyan),
            tooltip: 'Copy repository clone command',
            variant: M3EIconButtonVariant.standard,
            size: M3EIconButtonSize.xs,
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: _cmd));
              M3ESnackbar.show(
                context,
                message: 'Copied git clone command to clipboard',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HyprTilingShowcase extends StatelessWidget {
  const _HyprTilingShowcase({required this.tokens});

  final HyprTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top active Hyprland window: Terminal launcher
        HyprWindowFrame(
          title: 'kitty — chomsky@nixos',
          badge: 'ACTIVE • WAYLAND',
          alwaysActive: true,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TerminalLine(
                tokens: tokens,
                command: 'whoami && uname -sr',
                output: 'chomsky  •  Linux 7.x NixOS x86_64',
              ),
              const SizedBox(height: 14),
              _TerminalLine(
                tokens: tokens,
                command: 'ls -la ./apps/',
              ),
              const SizedBox(height: 8),
              _ClickableAppletRow(
                tokens: tokens,
                name: '01  m3e-snake',
                status: '[READY — CLICK TO LAUNCH]',
                isLive: true,
                onTap: () => context.go('/apps/snake'),
              ),
              const SizedBox(height: 6),
              _ClickableAppletRow(
                tokens: tokens,
                name: '02  bitfield-lab',
                status: '[PLANNED]',
                isLive: false,
                onTap: null,
              ),
              const SizedBox(height: 6),
              _ClickableAppletRow(
                tokens: tokens,
                name: '03  nixos-shell',
                status: '[PLANNED]',
                isLive: false,
                onTap: null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Bottom two split tiling windows (Hyprland dwindle split style)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: HyprWindowFrame(
                title: 'ws:2 — m3e-snake',
                badge: 'LIVE',
                onTap: () => context.go('/apps/snake'),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: CustomPaint(
                        painter: _MiniSnakePreviewPainter(tokens: tokens),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Play Snake',
                            style: TextStyle(
                              color: tokens.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'M3E Physics UI →',
                            style: tokens.monoStyle(
                              fontSize: 11.5,
                              color: tokens.mint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: HyprWindowFrame(
                title: 'dotfiles',
                badge: 'GIT',
                onTap: () => openExternalUrl(SiteData.nixosConfigUrl),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'nixos-config ↗',
                      style: TextStyle(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Declarative Flake • Wayland',
                      style: tokens.monoStyle(
                        fontSize: 11.5,
                        color: tokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TerminalLine extends StatelessWidget {
  const _TerminalLine({
    required this.tokens,
    required this.command,
    this.output,
  });

  final HyprTokens tokens;
  final String command;
  final String? output;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '❯ ',
              style: tokens.monoStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: tokens.mint,
              ),
            ),
            Expanded(
              child: Text(
                command,
                style: tokens.monoStyle(fontSize: 13, color: tokens.textPrimary),
              ),
            ),
          ],
        ),
        if (output != null) ...[
          const SizedBox(height: 4),
          Text(
            output!,
            style: tokens.monoStyle(fontSize: 12.5, color: tokens.textSecondary),
          ),
        ],
      ],
    );
  }
}

class _ClickableAppletRow extends StatefulWidget {
  const _ClickableAppletRow({
    required this.tokens,
    required this.name,
    required this.status,
    required this.isLive,
    required this.onTap,
  });

  final HyprTokens tokens;
  final String name;
  final String status;
  final bool isLive;
  final VoidCallback? onTap;

  @override
  State<_ClickableAppletRow> createState() => _ClickableAppletRowState();
}

class _ClickableAppletRowState extends State<_ClickableAppletRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final row = AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _hovered && widget.onTap != null
            ? widget.tokens.cyan.withValues(alpha: 0.12)
            : (widget.isLive
                ? widget.tokens.mint.withValues(alpha: 0.06)
                : const Color(0x00000000)),
        border: widget.isLive
            ? Border.all(
                color: _hovered
                    ? widget.tokens.mint
                    : widget.tokens.cyan.withValues(alpha: 0.3),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.name,
              style: widget.tokens.monoStyle(
                fontSize: 12.5,
                fontWeight: widget.isLive ? FontWeight.w700 : FontWeight.w400,
                color: widget.isLive
                    ? widget.tokens.textPrimary
                    : widget.tokens.textMuted,
              ),
            ),
          ),
          Text(
            widget.status,
            style: widget.tokens.monoStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: widget.isLive
                  ? widget.tokens.mint
                  : widget.tokens.textMuted,
            ),
          ),
        ],
      ),
    );

    if (widget.onTap == null) return row;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(onTap: widget.onTap, child: row),
    );
  }
}

class _MiniSnakePreviewPainter extends CustomPainter {
  const _MiniSnakePreviewPainter({required this.tokens});

  final HyprTokens tokens;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(12),
    );
    canvas.drawRRect(bg, Paint()..color = const Color(0xFF060B12));
    canvas.drawRRect(
      bg,
      Paint()
        ..color = tokens.borderIdle
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    const grid = 6;
    final cell = size.width / grid;
    final body = [
      const Offset(4, 2),
      const Offset(3, 2),
      const Offset(2, 2),
      const Offset(2, 3),
      const Offset(1, 3),
    ];

    for (var i = 0; i < body.length; i++) {
      final p = body[i];
      final rect = Rect.fromLTWH(
        p.dx * cell + 1.5,
        p.dy * cell + 1.5,
        cell - 3,
        cell - 3,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()
          ..color = i == 0
              ? tokens.mint
              : Color.lerp(tokens.cyan, tokens.indigo, i / body.length)!,
      );
    }

    // Glowing apple dot
    final apple = Offset(4.5 * cell, 4.5 * cell);
    canvas.drawCircle(apple, cell * 0.34, Paint()..color = tokens.cyan);
  }

  @override
  bool shouldRepaint(covariant _MiniSnakePreviewPainter oldDelegate) => false;
}
