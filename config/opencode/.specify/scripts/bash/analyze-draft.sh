#!/bin/bash
# analyze-draft.sh: Applies edits in tmp, generates draft.patch, and cats it.

set -e
while [[ $# -gt 0 ]]; do
  case $1 in
    --nnn) NNN="$2"; shift; shift ;;
    --edits) EDITS="$2"; shift; shift ;;  # e.g., 'spec.md "old" "new"; tasks.md "old" "new"'
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done
[ -z "$NNN" ] && { echo "Missing NNN"; exit 1; }

TMP_DIR="./tmp/$NNN-analysis"
[ ! -d "$TMP_DIR" ] && { echo "Run setup first"; exit 1; }

# Generate unified diff (multi-file)
pushd "$TMP_DIR"
> draft.patch
for orig in ./*.orig; do
  file="${orig%.orig}"
  if [ -f "$file" ]
  then
    diff --strip-trailing-cr -u "$orig" "$file" >> draft.patch || true
  fi
done
popd

# Show results
cat "$TMP_DIR/draft.patch"
echo "Draft patch generated and displayed from $TMP_DIR/draft.patch"
