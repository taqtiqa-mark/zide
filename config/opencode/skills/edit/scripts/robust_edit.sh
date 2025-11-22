#!/usr/bin/env bash
set -euo pipefail

# === robust_edit.sh – the ONLY script allowed to touch files ===
# Two-step workflow: prepare → edit → finalise
# Success → JSON output (idiomatic)
# Errors → stderr + exit 1 (idiomatic)

JSON_MODE=true  # always JSON on success (per project convention)

show_help() {
    cat << 'EOF'
Usage: robust_edit.sh --target <file> --step prepare|finalise [--mode apply|patch-only] [--help]

Mandatory two-step file editing with full traceability.

--target <path>     Target file (required for --step prepare)
--step prepare      Create temporary editable file and exit
--step finalise     Generate, validate, apply (if apply), save patch, report
--mode apply        (default) Apply changes after validation
--mode patch-only   Validate + save patch, do NOT apply
--help              Show this help

On success: outputs structured JSON
On error: prints to stderr and exits with status 1
EOF
    exit 0
}

# Parse arguments
TARGET=""
STEP=""
MODE="patch-only"
TMP_FILE=""
for arg in "$@"; do
    case "$arg" in
        --target) TARGET="$2"; shift 2 ;;
        --step)   STEP="$2"; shift 2 ;;
        --mode)   MODE="${2,,}"; shift 2 ;;
        --tmp_file) TMP_FILE="$2"; shift 2 ;;
        --help)   show_help ;;
        *) echo "ERROR: Unknown argument '$arg'" >&2; exit 1 ;;
    esac
done

[[ "$STEP" == "prepare" || "$STEP" == "finalise" ]] || { echo "ERROR: --step prepare|finalise required" >&2; exit 1; }
[[ "$STEP" == "prepare" ]] && [[ -z "$TARGET" ]] && { echo "ERROR: --target required for --step prepare" >&2; exit 1; }
[[ "$MODE" =~ ^(apply|patch-only)$ ]] || MODE="patch-only"

project_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
state_dir="$project_root"

if [[ "$STEP" == "prepare" ]]; then
    tmpdir=$(mktemp -d "${project_root}/.robust-edit-tmp.XXXXXX")
    original_path=$(realpath "$TARGET" 2>/dev/null || echo "$project_root/$TARGET")

    echo "$tmpdir" > "$state_dir/.robust-edit-last-tmp"
    echo "$original_path" > "$state_dir/.robust-edit-last-target"
    echo "$MODE" > "$state_dir/.robust-edit-last-mode"

    if [ -r "$original_path" ]; then
        cp "$original_path" "$tmpdir/file.orig"
    else
        touch "$tmpdir/file.orig"
    fi
    cp "$tmpdir/file.orig" "$tmpdir/file.modified"

    # CRLF → LF
    dos2unix "$tmpdir/file.orig" "$tmpdir/file.modified" 2>/dev/null || \
        perl -pi -e 's/\r$//' "$tmpdir/file.orig" "$tmpdir/file.modified" || true

    # Success JSON
    printf '{"status":"READY","tmp_file":"%s","next_command":"bash scripts/robust_edit.sh --step finalise --mode %s --tmp_file %s"}\n' \
        "$tmpdir/file.modified" "$MODE" "$tmpdir/file.modified"

    exit 0
fi

# === STEP finalise ===
# Prefer explicit --tmp_file if provided (supports Skill's next_command), fallback to state file
tmpdir="${TMP_FILE:-$(cat "$state_dir/.robust-edit-last-tmp")}"
original_path=$(cat "$state_dir/.robust-edit-last-target")
# Prefer explicit --mode if provided, fallback to stored mode
MODE="${MODE:-$(cat "$state_dir/.robust-edit-last-mode")}"
dirname=$(dirname "$original_path")
basename=$(basename "$original_path")

# Robustness loop – fix literal \\n
attempt=0
while (( attempt++ < 3 )); do
    if [[ -s "$tmpdir/file.orig" ]]; then
        diff -u -L "a/$basename" -L "b/$basename" \
            "$tmpdir/file.orig" "$tmpdir/file.modified"
    else
        diff -u /dev/null "$tmpdir/file.modified" -L "a/$basename" -L "b/$basename"
    fi > "$tmpdir/patch.diff" || touch "$tmpdir/patch.diff"

    if grep -q '\\\\n' "$tmpdir/patch.diff"; then
        sed -i 's/\\\\n/\n/g' "$tmpdir/file.modified"
        continue
    fi
    break
done

# Validate
if ! (cd "$dirname" && git apply --check "$tmpdir/patch.diff"); then
    echo "ERROR: Patch does not apply cleanly" >&2
    cat "$tmpdir/patch.diff" >&2
    rm -rf "$tmpdir" 2>/dev/null || true
    exit 1
fi

# Apply
if [[ "$MODE" == "apply" ]]; then
    (cd "$dirname" && git apply "$tmpdir/patch.diff") || {
        echo "ERROR: Conflict during apply" >&2
        rm -rf "$tmpdir" 2>/dev/null || true
        exit 1
    }
fi

# Save patch
timestamp=$(date +%Y%m%d-%H%M%S)
patch_path="$dirname/${basename%.*}-$timestamp.patch"
cp "$tmpdir/patch.diff" "$patch_path"

# Cleanup
rm -rf "$tmpdir"
rm -f "$state_dir/.robust-edit-last-"* 2>/dev/null || true

# Success JSON (idiomatic)
printf '{"status":"SUCCESS","saved_patch":"%s","mode":"%s","target":"%s"}\n' \
    "$patch_path" "$MODE" "$original_path"

