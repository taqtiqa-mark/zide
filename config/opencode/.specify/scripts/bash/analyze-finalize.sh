#!/bin/bash
# analyze-finalize.sh: Copies draft.patch to FEATURE_DIR/NNN-analysis.patch.

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
[ ! -f "$TMP_DIR/draft.patch" ] && { echo "Run draft first"; exit 1; }

PATCH_FILE="$FEATURE_DIR/$NNN-analysis.patch"
cp "$TMP_DIR/draft.patch" "$PATCH_FILE"
echo "Patch copied to $PATCH_FILE (not applied)"
