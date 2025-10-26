---
name: explore-code
description: Pack, explore, outline and analyze codebases into AI-friendly formats using the repomix CLI. Use when users request to pack code for AI consumption, explore repository structure, search for patterns, or generate metrics from local or remote GitHub repositories. Triggers on phrases like "Pack my code for AI", "Explore this repo", or "Outline this codebase".
---

# Repomix Codebase Packer and Explorer

## Overview

Pack repositories into single files optimized for AI analysis (XML, Markdown, JSON, plain) and explore their contents efficiently. Handle local directories or remote GitHub repos with options for compression, file filtering, and output customization.

Apply this skill to:
- Generate packed outputs for feeding into LLMs.
- Analyze structure, patterns, and metrics without loading full content into context.
- Delegate detailed analysis to sub-agents for token efficiency.

## When to Use

Invoke when:
- User requests packing a codebase (e.g., "Pack this project for AI").
- User asks to explore or analyze a repo (e.g., "Outline this codebase" or "Find authentication code in facebook/react").
- Work involves remote GitHub repos or local paths.
- Analysis requires incremental searching (grep) or reading to avoid context overload.

For simple file reading without packing, use standard tools instead.

## Core Workflow

To pack and/or analyze:
1. Parse user intent to determine local/remote, options (e.g., compress, include patterns), and analysis focus. See [references/PACK_LOCAL.md](references/PACK_LOCAL.md) for local-specific option handling or [references/PACK_REMOTE.md](references/PACK_REMOTE.md) for remote-specific handling.
2. Run `npx repomix@latest` with appropriate flags.
3. If analysis requested, note output file and delegate to sub-agent (prefer repomix-explorer:explorer if available).
4. Report findings with references to file paths, snippets, and metrics.

## Key Commands

Run repomix via Bash tool:
- Local: `npx repomix@latest [path] [options]`
- Remote: `npx repomix@latest --remote [repo] [options]`

Common options:
- `--style <format>`: xml (default), markdown, json, plain.
- `--compress`: Reduce tokens by ~70% with Tree-sitter.
- `--include <patterns>`: e.g., "**/*.ts,**/*.md".
- `--ignore <patterns>`: Additional exclusions.
- `--copy`: Copy output to clipboard.
- `--include-diffs`, `--include-logs`: Add git history.

For full reference, see [references/CLI_REFERENCE.md](references/CLI_REFERENCE.md).

## Analysis Guidelines

Avoid reading entire output files:
- Use Grep for patterns (e.g., `grep -i "auth" repomix-output.xml`).
- Use Read tool incrementally with offsets/limits.
- Delegate to sub-agent with task: "Analyze [file] using Grep and Read. Provide overview of structure and [focus]. Do not read entire file."

If repomix-explorer:explorer available, launch with Task tool and instructions template from [references/EXPLORE_LOCAL.md](references/EXPLORE_LOCAL.md) or [references/EXPLORE_REMOTE.md](references/EXPLORE_REMOTE.md).

## Error Handling

- Command fails: Check repo URL/path, permissions; suggest alternatives.
- Large outputs: Enable `--compress`; narrow with `--include`.
- Pattern not found: Broaden search; verify file tree.

For workflows and checklists, see [references/WORKFLOWS.md](references/WORKFLOWS.md).
For dependency on sub-agents, see [references/EXPLORER.md](references/EXPLORER.md).

## Reference Files

| Reference | Read When |
|-----------|-----------|
| [references/PACK_LOCAL.md](references/PACK_LOCAL.md) | Handling local packing intents and options. |
| [references/PACK_REMOTE.md](references/PACK_REMOTE.md) | Handling remote GitHub packing. |
| [references/EXPLORE_LOCAL.md](references/EXPLORE_LOCAL.md) | Launching analysis for local codebases. |
| [references/EXPLORE_REMOTE.md](references/EXPLORE_REMOTE.md) | Launching analysis for remote repos. |
| [references/EXPLORER.md](references/EXPLORER.md) | Sub-agent behavior for exploration. |
| [references/CLI_REFERENCE.md](references/CLI_REFERENCE.md) | Detailed command flags and examples. |
| [references/WORKFLOWS.md](references/WORKFLOWS.md) | Step-by-step processes and checklists. |
