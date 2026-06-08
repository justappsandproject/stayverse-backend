#!/usr/bin/env bash
set -euo pipefail

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

ROOT="/Users/admin/Desktop/STAYVERSE"
OUT_DIR="$ROOT/builds"
DATE_TAG="$(date +%Y%m%d-%H%M)"
mkdir -p "$OUT_DIR"

log() { echo "[build] $*"; }

pkill -f "GradleDaemon" 2>/dev/null || true
cd "$ROOT/stayverse-user-app-master/android" && ./gradlew --stop 2>/dev/null || true
cd "$ROOT/stayverse-agent-app-master/android" && ./gradlew --stop 2>/dev/null || true

build_apk() {
  local app_dir="$1"
  local out_name="$2"
  log "APK: $out_name"
  cd "$app_dir"
  flutter pub get
  flutter build apk --debug
  local apk_src="$app_dir/build/app/outputs/flutter-apk/app-debug.apk"
  if [[ ! -f "$apk_src" ]]; then
    echo "APK not found at $apk_src" >&2
    exit 1
  fi
  cp "$apk_src" "$OUT_DIR/${out_name}-${DATE_TAG}.apk"
  cp "$apk_src" "$OUT_DIR/${out_name}-latest.apk"
  log "Saved $OUT_DIR/${out_name}-latest.apk"
}

build_ipa() {
  local app_dir="$1"
  local out_name="$2"
  log "IPA: $out_name"
  cd "$app_dir/ios"
  pod install || true
  cd "$app_dir"
  flutter pub get
  flutter build ipa --debug --export-method debugging || flutter build ios --debug --no-codesign
  local ipa_src
  ipa_src="$(find "$app_dir/build/ios/ipa" -name '*.ipa' | head -1)"
  if [[ -z "$ipa_src" || ! -f "$ipa_src" ]]; then
    echo "IPA not found under $app_dir/build/ios/ipa" >&2
    exit 1
  fi
  cp "$ipa_src" "$OUT_DIR/${out_name}-${DATE_TAG}.ipa"
  cp "$ipa_src" "$OUT_DIR/${out_name}-latest.ipa"
  log "Saved $OUT_DIR/${out_name}-latest.ipa"
}

log "Output directory: $OUT_DIR"
build_apk "$ROOT/stayverse-user-app-master" "stayverse-user"
build_apk "$ROOT/stayverse-agent-app-master" "stayverse-agent"
build_ipa "$ROOT/stayverse-user-app-master" "stayverse-user"
build_ipa "$ROOT/stayverse-agent-app-master" "stayverse-agent"

cat > "$OUT_DIR/README.txt" <<EOF
Stayverse mobile test builds — ${DATE_TAG}

Android (install via file manager or adb install):
  - stayverse-user-latest.apk
  - stayverse-agent-latest.apk

iOS (install via Xcode Devices, Apple Configurator, or TestFlight after signing):
  - stayverse-user-latest.ipa
  - stayverse-agent-latest.ipa

Folder: $OUT_DIR
EOF

log "All builds complete."
