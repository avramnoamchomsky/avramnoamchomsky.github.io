#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

flutter build web --release --base-href "/" --no-web-resources-cdn

rm -rf assets canvaskit icons \
  index.html flutter.js flutter_bootstrap.js flutter_service_worker.js \
  main.dart.js main.dart.mjs main.dart.wasm \
  manifest.json version.json favicon.png

cp -r build/web/assets build/web/canvaskit build/web/icons .
cp build/web/index.html \
  build/web/flutter.js \
  build/web/flutter_bootstrap.js \
  build/web/flutter_service_worker.js \
  build/web/main.dart.js \
  build/web/manifest.json \
  build/web/version.json \
  build/web/favicon.png \
  .

touch .nojekyll
echo "Synced build/web to repository root for GitHub Pages."
