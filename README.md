# avramnoamchomsky.github.io

My personal website and cross-platform mini-app hub built with **Flutter** and **Material 3 Expressive (`material_3_expressive`)**.

Live site: [avramnoamchomsky.github.io](https://avramnoamchomsky.github.io)

## Architecture

- **Homepage (`/`):** Hyprland-inspired dark cyber-minimalist landing page featuring tiled window frames, cyan-to-mint active borders, focus domains, environment stack, and sub-app entry cards.
- **Secondary Sub-Apps (`/#/apps/*`):**
  - **M3E Snake (`/#/apps/snake`):** Playable Snake applet built with Material 3 Expressive (`M3EAppBar`, `M3ECard`, `M3EButton`, `M3EButtonGroup`, `M3ESegmentedButton`, `M3ESwitch`, `M3EChip`, `M3EIconButton`, `M3EDialog`, `M3ESnackbar`), supporting keyboard (`Arrow`/`WASD`/`Space`/`R`), swipe gestures, D-pad, wrap-wall mode, and dynamic M3E seed themes.

## Development

```bash
# Run static analysis and tests
flutter analyze
flutter test

# Run locally on Web or Linux desktop
flutter run -d chrome
flutter run -d linux
```

## Deploying to GitHub Pages

This repository serves compiled static web assets from the root of `main` (with `.nojekyll` and local CanvasKit via `--no-web-resources-cdn`) so pushing `main` updates `avramnoamchomsky.github.io` directly.

After making changes in `lib/` or `web/`, rebuild and sync the root deployment bundle before committing:

```bash
./tool/sync_pages.sh
```

## Project Structure

```text
.
├── lib/
│   ├── main.dart
│   ├── app/              # MaterialApp.router + GoRouter routes
│   ├── core/             # HyprTokens theme, backdrop, window frame, URL helper
│   ├── data/             # Typed site content & sub-app registry
│   └── features/
│       ├── home/         # Hyprland-inspired homepage & navigation
│       └── snake/        # Material 3 Expressive Snake sub-app + game engine
├── test/                 # Engine unit tests & desktop/mobile widget tests
├── tool/sync_pages.sh    # Rebuilds release web bundle and syncs root files
├── web/                  # Flutter web host template (index.html, manifest, icons)
└── linux/                # Linux desktop runner
```
