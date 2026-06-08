#!/usr/bin/env bash
set -euo pipefail
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

ROOT="/Users/admin/Desktop/STAYVERSE"
OUT="$ROOT/builds"
TEAM_ID="${DEVELOPMENT_TEAM:-24FD8NBQ48}"
mkdir -p "$OUT"

build_ipa() {
  local dir="$1" name="$2" log="$OUT/${name}-ipa.log"
  echo "=== Building IPA: $name ===" | tee "$log"
  cd "$dir"
  flutter pub get 2>&1 | tee -a "$log"
  flutter build ipa \
    --debug \
    --export-method development \
    --allow-provisioning-updates \
    2>&1 | tee -a "$log"

  local ipa
  ipa="$(find "$dir/build/ios/ipa" -name '*.ipa' 2>/dev/null | head -1)"
  if [[ -z "$ipa" ]]; then
    ipa="$(find "$dir/build/ios/archive" -name '*.ipa' 2>/dev/null | head -1)"
  fi
  if [[ -z "$ipa" ]]; then
    echo "ERROR: No IPA produced for $name" | tee -a "$log"
    return 1
  fi
  cp -f "$ipa" "$OUT/${name}-latest.ipa"
  ls -lh "$OUT/${name}-latest.ipa" | tee -a "$log"
  echo "OK: $name IPA -> $OUT/${name}-latest.ipa" | tee -a "$log"
}

build_ipa "$ROOT/stayverse-user-app-master" "stayverse-user"
build_ipa "$ROOT/stayverse-agent-app-master" "stayverse-agent"

cat > "$OUT/README.txt" <<EOF
Stayverse test builds — $(date)

Download from this folder:
$OUT

Android (debug APK):
  stayverse-user-latest.apk
  stayverse-agent-latest.apk

iOS (debug development IPA):
  stayverse-user-latest.ipa
  stayverse-agent-latest.ipa

Install Android: transfer APK to device and open, or: adb install <file>.apk
Install iOS (development): register device in Apple Developer, then Xcode → Window → Devices and Simulators → install .ipa
EOF

echo "All IPAs ready in $OUT"
