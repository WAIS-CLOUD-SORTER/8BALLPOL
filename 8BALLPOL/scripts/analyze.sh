#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

JAVA_HOME="$(pwd)/.work/tools/jdk_extract/jdk-17.0.21.1+2"
export PATH="$JAVA_HOME/bin:$PATH"

APK="${1:-analysis/8ballpool.apk}"
OUT="analysis/output"

mkdir -p "$OUT"
jadx -d "$OUT/source" -ds "$OUT/res" -r -j 2 "$APK"
find "$OUT" -name '*.so' -type f > "$OUT/.so_list" 2>/dev/null || true
echo "Hecho: $OUT"
