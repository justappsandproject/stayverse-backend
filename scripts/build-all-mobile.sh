#!/usr/bin/env bash
set -uo pipefail

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

ROOT="/Users/admin/Desktop/STAYVERSE"
OUT="$ROOT/builds"
mkdir -p "$OUT"
LOG="$OUT/build-all.log"
: > "$LOG"

log() { echo "[$(date +%H:%M:%S)] $*" | tee -a "$LOG"; }

build_apk() {
  local dir="$1" name="$2"
  log "=== APK: $name ==="
  cd "$dir" || return 1
  flutter pub get >>"$LOG" 2>&1 || return 1
  if flutter build apk --debug >>"$LOG" 2>&1; then
    local src="$dir/build/app/outputs/flutter-apk/app-debug.apk"
    if [[ -f "$src" ]]; then
      cp -f "$src" "$OUT/${name}-latest.apk"
      log "OK: $OUT/${name}-latest.apk ($(du -h "$OUT/${name}-latest.apk" | cut -f1))"
      return 0
    fi
  fi
  log "FAIL: $name APK"
  return 1
}

build_ipa() {
  local dir="$1" name="$2"
  log "=== IPA: $name ==="
  cd "$dir/ios" || return 1
  pod install >>"$LOG" 2>&1 || log "pod install warning (continuing)"
  cd "$dir" || return 1
  flutter pub get >>"$LOG" 2>&1 || return 1
  if flutter build ipa --debug --export-method debugging >>"$LOG" 2>&1; then
    local ipa
    ipa="$(find "$dir/build/ios/ipa" -name '*.ipa' 2>/dev/null | head -1)"
    if [[ -n "$ipa" && -f "$ipa" ]]; then
      cp -f "$ipa" "$OUT/${name}-latest.ipa"
      log "OK: $OUT/${name}-latest.ipa ($(du -h "$OUT/${name}-latest.ipa" | cut -f1))"
      return 0
    fi
  fi
  log "FAIL: $name IPA"
  return 1
}

log "Output: $OUT"
build_apk "$ROOT/stayverse-user-app-master" "stayverse-user" || true
build_apk "$ROOT/stayverse-agent-app-master" "stayverse-agent" || true
build_ipa "$ROOT/stayverse-user-app-master" "stayverse-user" || true
build_ipa "$ROOT/stayverse-agent-app-master" "stayverse-agent" || true

cat > "$OUT/README.txt" <<EOF
Stayverse test builds — $(date)

Download from this folder:
$OUT

Android (debug APK):
  stayverse-user-latest.apk
  stayverse-agent-latest.apk

iOS (debug IPA):
  stayverse-user-latest.ipa
  stayverse-agent-latest.ipa

Install Android: transfer APK to device and open, or: adb install <file>.apk
Install iOS: Xcode → Devices and Simulators → install .ipa

Full log: $LOG
EOF

log "=== Summary ==="
ls -lh "$OUT"/*.apk "$OUT"/*.ipa 2>/dev/null || log "Some artifacts missing — see $LOG"
