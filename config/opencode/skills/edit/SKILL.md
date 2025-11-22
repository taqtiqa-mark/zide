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

# Robust Edit Skill (Two-Step – Project-Wide Mandatory)

You are the **exclusive**, **non-negotiable** gateway for **all** file creation and modification in this project.

**Direct use of `Edit` or `Write` tools on real files is strictly forbidden.**  
All other Skills and subagents have these tools removed from `allowed-tools` — they **must** delegate here.

One file per invocation. Multiple files requested → refuse and ask for separate invocations.

**Supported modes** (passed via `--mode`)
- `apply` (default) → validate + apply + save patch
- `patch-only` → validate + save patch, **do NOT apply**

### Step 0 - Determine the Mode

Either the User or another prompt must set the mode as patch-only OR apply.

### Step 1 – Prepare Temporary Editable File

Patch only mode (DEFAULT): Only create the patch file, do not apply it. 

```bash
bash scripts/robust_edit.sh --target "path/to/file.ext" --step prepare --mode patch-only
```

Apply mode: Create the patch file AND apply it

```bash
bash scripts/robust_edit.sh --target "path/to/file.ext" --step prepare --mode apply
```

**Output (JSON on success in APPLY mode):**

```json
{
  "status": "READY",
  "tmp_file": "/full/path/to/.robust-edit-tmp.abCD12/file.modified",
  "next_command": "bash scripts/robust_edit.sh --step finalise --mode apply --tmp_file /full/path/to/.robust-edit-tmp.abCD12/file.modified"
}
```

**Output (JSON on success in PATCH-ONLY mode):**

```json
{
  "status": "READY",
  "tmp_file": "/full/path/to/.robust-edit-tmp.abCD12/file.modified",
  "next_command": "bash scripts/robust_edit.sh --step finalise --mode patch-only --tmp_file /full/path/to/.robust-edit-tmp.abCD12/file.modified"
}
```

You **MUST NOW** perform all edits using `Edit` or `Write` tools **EXCLUSIVELY** on the path given in `tmp_file`.

### Step 2 – Finalise (run only when all edits to tmp_file are complete)

```bash
bash scripts/robust_edit.sh --step finalise --mode apply --tmp_file /full/path/to/.robust-edit-tmp.abCD12/file.modified
```

**Output (JSON on success in APPLY mode):**

```json
{
  "status": "SUCCESS",
  "saved_patch": "/path/to/file-20251121-142300.patch",
  "mode": "apply",
  "target": "/path/to/file.ext"
}
```

**Output (JSON on success in PATCH-ONLY mode):**

```json
{
  "status": "SUCCESS",
  "saved_patch": "/path/to/file-20251121-142300.patch",
  "mode": "patch-only",
  "target": "/path/to/file.ext"
}
```

**Guaranteed behavior (enforced by script):**

- Project-local temporary workspace (`.robust-edit-tmp.XXXXXX`)
- Automatic CRLF → LF normalization
- Up to 3 attempts to fix literal `\\n` in content
- Basename-only patch headers
- Full `git apply --check` validation
- Atomic apply via `git apply` (apply mode only)
- Dated `.patch` file saved next to the real target
- Full cleanup of temp and state files
- Errors always go to stderr with exit 1

**You must never bypass this Skill.**  

This is the only safe, traceable, and auditable way to change files in this codebase.
