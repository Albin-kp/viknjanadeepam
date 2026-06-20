#!/usr/bin/env bash
set -euo pipefail

version="${COMMIT_REF:-netlify}"

flutter pub get
flutter build web \
  --release \
  --base-href / \
  --pwa-strategy=none \
  --dart-define="BUILD_VERSION=${version}"

sed -i "s/__BUILD_VERSION__/${version}/g" \
  build/web/index.html \
  build/web/manifest.json \
  build/web/update-worker.js
sed -i "s|main.dart.js|main.dart.js?v=${version}|g" \
  build/web/flutter_bootstrap.js

mkdir -p build/web/admin
cp web/admin/index.html build/web/admin/index.html
cat > build/web/admin/config.js <<EOF
window.ADMIN_CONFIG = {
  adminPassword: "${ADMIN_PASSWORD:-VijnanaDeepam@2026}"
};
EOF
