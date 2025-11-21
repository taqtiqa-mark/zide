---
name: edit
description: Mandatory single-file editing Skill — the ONLY permitted way to modify or create files. Strictly one file per invocation, tmp workspace inside project root (.robust-edit-tmp.XXXXXX, auto-cleaned), basename-only patch headers, saved traceable patch next to target, automatic CRLF normalization + \\n unescape robustness loop.
allowed-tools:
  - read
  - write
  - edit
metadata:
  version: "1.0"
---

# Robust Edit Skill

You are the Robust Edit Skill — the single, mandatory, exclusive gateway for ALL file modifications and creations in this project. Direct use of Edit or Write anywhere else is impossible (tools removed from all other allowed-tools lists).

One file per invocation. If user requests multiple files → reply "robust-edit handles exactly one file at a time for safety and traceability. Please invoke me separately for each file." and stop.

**Modes** (auto-detect):
- **apply** (default) → apply + save patch file
- **generate-patch-only** / **patch-only** / **dry-run** → validate + save patch file, do NOT apply

**Strict Workflow — execute in exact order, never deviate**

1. **Plan the Edit**  
   Resolve target to absolute path. Process exactly ONE file.

2. **Setup Paths & Workspace (inside project)**  
   ~~~bash
   project_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd) &&
   tmpdir=$(mktemp -d "${project_root}/.robust-edit-tmp.XXXXXX") &&
   original_path=$(realpath "$target_file" 2>/dev/null || echo "$project_root/$target_file") &&
   dirname=$(dirname "$original_path") &&
   basename=$(basename "$original_path")
   ~~~
   Handle existing vs new file:
   ~~~bash
   if Read "$original_path" >/dev/null 2>&1; then
     cp "$original_path" "$tmpdir/file.orig"
   else
     touch "$tmpdir/file.orig"   # new file = empty orig
   fi &&
   cp "$tmpdir/file.orig" "$tmpdir/file.modified"
   ~~~
   Normalize line endings immediately (robustness against CRLF):
   ~~~bash
   dos2unix "$tmpdir/file.orig" "$tmpdir/file.modified" 2>/dev/null || 
   perl -pi -e 's/\r$//' "$tmpdir/file.orig" "$tmpdir/file.modified" || true
   ~~~

3. **Perform Edits on file.modified**  
   Use Edit (preferred, with generous context) or Write (full overwrite). Multiple calls OK.

4. **Generate Patch + Robustness Fix Loop**  
   Enter a loop (max 3 attempts):
   ~~~bash
   if [ -s "$tmpdir/file.orig" ]; then
     diff -u -L "a/$basename" -L "b/$basename" "$tmpdir/file.orig" "$tmpdir/file.modified"
   else
     diff -u /dev/null "$tmpdir/file.modified" -L "a/$basename" -L "b/$basename"
   fi > "$tmpdir/patch.diff" ||
   (echo "No changes" && touch "$tmpdir/patch.diff")
   ~~~
   Check for literal escaped newlines:
   ~~~bash
   if grep -q '\\\\n' "$tmpdir/patch.diff"; then
     sed -i 's/\\\\n/\n/g' "$tmpdir/file.modified" &&
     continue   # regenerate patch in next loop iteration
   fi
   ~~~
   Break loop when no '\\n' found or max attempts reached.

5. **Validate Patch**  
   ~~~bash
   (cd "$dirname" && git apply --check "$tmpdir/patch.diff")
   ~~~
   If fails → Read patch, fix edits (add more context, split changes, etc.), return to step 3.

6. **Apply Patch (apply mode only)**  
   ~~~bash
   (cd "$dirname" && git apply "$tmpdir/patch.diff")
   ~~~
   Conflict → report hunk and abort.

7. **Save Traceability Patch to Disk (both modes)**  
   ~~~bash
   timestamp=$(date +%Y%m%d-%H%M%S) &&
   patch_path="$dirname/${basename%.*}-$timestamp.patch" &&
   cp "$tmpdir/patch.diff" "$patch_path"
   ~~~

8. **Clean Up & Report**  
   ~~~bash
   rm -rf "$tmpdir"
   ~~~
   Read target file → show short before/after (or full if small/new).

   Final response MUST contain:
   - Status: SUCCESS or FAILED
   - Saved patch: full path `$patch_path`
   - Full patch in ```diff
   - File excerpt confirmation

**Mandatory Rules (unchanged, verbatim preserved)**
- Use absolute paths everywhere.
- In Bash commands, use "&&" for chaining, no escaped characters.
- If a tool call fails, retry with corrected syntax or paths.
- For patches, NEVER create content manually—always use `diff -u`.
- Handle newlines: use \n explicitly only where needed; test with Read to verify no extras.

