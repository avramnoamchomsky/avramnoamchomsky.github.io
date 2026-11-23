import 'package:material_ui/material_ui.dart';

/// Descriptor for a sub-app applet launched from the homepage.
@immutable
class SubAppEntry {
  const SubAppEntry({
    required this.id,
    required this.indexLabel,
    required this.title,
    required this.category,
    required this.description,
    required this.tags,
    required this.icon,
    required this.isLive,
    this.route,
    this.accentColor = const Color(0xFF33CCFF),
  });

  final String id;
  final String indexLabel;
  final String title;
  final String category;
  final String description;
  final List<String> tags;
  final IconData icon;
  final bool isLive;
  final String? route;
  final Color accentColor;
}

@immutable
class FocusDomain {
  const FocusDomain({
    required this.indexLabel,
    required this.title,
    required this.description,
    required this.tags,
    required this.glyph,
    this.featured = false,
  });

  final String indexLabel;
  final String title;
  final String description;
  final List<String> tags;
  final String glyph;
  final bool featured;
}

abstract final class SiteData {
  static const String githubProfileUrl = 'https://github.com/avramnoamchomsky';
  static const String nixosConfigUrl =
      'https://github.com/avramnoamchomsky/nixos-config';
  static const String siteRepoUrl =
      'https://github.com/avramnoamchomsky/avramnoamchomsky.github.io';

  static const List<SubAppEntry> subApps = [
    SubAppEntry(
      id: 'snake',
      indexLabel: '01',
      title: 'M3E Snake',
      category: 'INTERACTIVE GAME • M3E',
      description:
          'Classic arcade Snake rebuilt as a Material 3 Expressive applet — '
          'spring-physics controls, dynamic seed theming, wrap-wall mode, and keyboard + touch support.',
      tags: ['Material 3 Expressive', 'CustomPainter', 'Keyboard + Touch'],
      icon: Icons.videogame_asset_rounded,
      isLive: true,
      route: '/apps/snake',
      accentColor: Color(0xFF58E1FF),
    ),
    SubAppEntry(
      id: 'bitfield',
      indexLabel: '02',
      title: 'Bitfield & Register Lab',
      category: 'SYSTEMS UTILITY • PLANNED',
      description:
          'Interactive 32/64-bit register decoder, hex/binary inspector, and '
          'bitwise mask visualizer designed for embedded & firmware work.',
      tags: ['M3E', 'Embedded', 'Offline Tool'],
      icon: Icons.memory_rounded,
      isLive: false,
      accentColor: Color(0xFF00A2F8),
    ),
    SubAppEntry(
      id: 'shell',
      indexLabel: '03',
      title: 'chomsky@nixos Shell',
      category: 'TERMINAL & NOTES • PLANNED',
      description:
          'Interactive command palette and Markdown learning log covering NixOS, '
          'Wayland compositors, Linux internals, and low-level notes.',
      tags: ['M3E', 'Markdown', 'Cross-Platform'],
      icon: Icons.terminal_rounded,
      isLive: false,
      accentColor: Color(0xFFC084FC),
    ),
  ];

  static const List<FocusDomain> focusDomains = [
    FocusDomain(
      indexLabel: '01',
      title: 'Embedded Systems',
      description:
          'Microcontrollers, hardware interfaces, bare-metal firmware, and '
          'resource-constrained computing.',
      tags: ['MCU', 'Firmware', 'Hardware'],
      glyph: '◈',
    ),
    FocusDomain(
      indexLabel: '02',
      title: 'Linux & NixOS',
      description:
          'Declarative system configuration, Wayland compositors, userspace '
          'tooling, and kernel internals.',
      tags: ['NixOS', 'Wayland', 'Systems'],
      glyph: 'λ',
      featured: true,
    ),
    FocusDomain(
      indexLabel: '03',
      title: 'Low-Level Software',
      description:
          'Memory models, computer architecture, compilers, and building '
          'cross-platform tools close to the machine.',
      tags: ['C', 'Architecture', 'Flutter'],
      glyph: '</>',
    ),
  ];

  static const List<String> environmentStack = [
    'NixOS',
    'Linux',
    'Wayland / niri / Hyprland',
    'Nix',
    'Flutter & Dart',
    'C',
    'Git',
    'GitHub',
  ];
}
