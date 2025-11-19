#!/bin/bash
# analyze-setup.sh: Prepares tmp/NNN-analysis with original files.

set -e
while [[ $# -gt 0 ]]; do
  case $1 in
    --feature-dir) FEATURE_DIR="$2"; shift; shift ;;
    --nnn) NNN="$2"; shift; shift ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done
[ -z "$NNN" ] || [ -z "$FEATURE_DIR" ] && { echo "Missing args"; exit 1; }

TMP_DIR="./tmp/$NNN-analysis"
mkdir -p "$TMP_DIR"
cp "$FEATURE_DIR/spec.md" "$TMP_DIR/spec.md.orig" || true
cp "$FEATURE_DIR/plan.md" "$TMP_DIR/plan.md.orig" || true
cp "$FEATURE_DIR/tasks.md" "$TMP_DIR/tasks.md.orig" || true
echo "Setup complete in $TMP_DIR"
