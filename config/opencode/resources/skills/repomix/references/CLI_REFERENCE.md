# CLI Reference

Complete command reference for repomix CLI tool. All options support standard usage as shown in `repomix --help`.

## Contents

- [Quick Reference](#quick-reference)
- [Arguments](#arguments)
- [Basic Options](#basic-options)
- [CLI Input/Output Options](#cli-input-output-options)
- [Repomix Output Options](#repomix-output-options)
- [File Selection Options](#file-selection-options)
- [Remote Repository Options](#remote-repository-options)
- [Configuration Options](#configuration-options)
- [Security Options](#security-options)
- [Token Count Options](#token-count-options)
- [MCP Options](#mcp-options)
- [Help Options](#help-options)
- [Command Examples](#command-examples)
- [Tips](#tips)

## Quick Reference

| Category | Key Options | Purpose |
|----------|-------------|---------|
| Basic | `-v, --version` | Show version |
| Input/Output | `--verbose`, `--quiet`, `--stdout`, `--stdin`, `--copy`, `--token-count-tree [threshold]`, `--top-files-len <number>` | Control logging, output, and summaries |
| Output | `-o, --output <file>`, `--style <type>`, `--compress`, `--include-diffs`, `--include-logs` | Customize format, compression, and content |
| File Selection | `--include <patterns>`, `-i, --ignore <patterns>`, `--no-gitignore` | Filter files |
| Remote | `--remote <url>`, `--remote-branch <name>` | Pack remote repos |
| Config | `-c, --config <path>`, `--init`, `--global` | Manage config |
| Security | `--no-security-check` | Skip sensitive data scan |
| Token | `--token-count-encoding <encoding>` | Set tokenizer |
| MCP | `--mcp` | Run as server |
| Help | `-h, --help` | Show help |

## Arguments

- `directories...`: List of directories to process (default: ["."]).

## Basic Options

- `-v, --version`: Show version information and exit.

## CLI Input/Output Options

- `--verbose`: Enable detailed debug logging (file processing, token counts, config).
- `--quiet`: Suppress all console output except errors (for scripting).
- `--stdout`: Write output to stdout instead of file (suppresses logging).
- `--stdin`: Read file paths from stdin, one per line (processes specified files).
- `--copy`: Copy output to clipboard after processing.
- `--token-count-tree [threshold]`: Show file tree with token counts; optional threshold for files ≥N tokens (e.g., --token-count-tree 100).
- `--top-files-len <number>`: Number of largest files in summary (default: 5, e.g., --top-files-len 20).

## Repomix Output Options

- `-o, --output <file>`: Output file path (default: repomix-output.xml, "-" for stdout).
- `--style <type>`: Format: xml (default), markdown, json, plain.
- `--parsable-style`: Escape special characters for valid XML/Markdown.
- `--compress`: Extract structures (classes, functions) with Tree-sitter (~70% token reduction).
- `--output-show-line-numbers`: Prefix lines with numbers.
- `--no-file-summary`: Omit file summary.
- `--no-directory-structure`: Omit directory tree.
- `--no-files`: Generate metadata only.
- `--remove-comments`: Strip code comments.
- `--remove-empty-lines`: Remove blank lines.
- `--truncate-base64`: Truncate long base64 strings.
- `--header-text <text>`: Custom header text.
- `--instruction-file-path <path>`: Path to custom instructions file.
- `--include-empty-directories`: Include empty folders in structure.
- `--include-full-directory-structure`: Show full tree even with --include.
- `--no-git-sort-by-changes`: Don't sort by git change frequency.
- `--include-diffs`: Add git diff for working/staged changes.
- `--include-logs`: Add git commit history.
- `--include-logs-count <count>`: Recent commits with --include-logs (default: 50).

## File Selection Options

- `--include <patterns>`: Include matching globs (comma-separated, e.g., "src/**/*.js,*.md").
- `-i, --ignore <patterns>`: Additional exclude patterns (e.g., "*.test.js,docs/**").
- `--no-gitignore`: Ignore .gitignore rules.
- `--no-default-patterns`: Ignore built-in ignores (node_modules, .git, etc.).

## Remote Repository Options

- `--remote <url>`: Clone and pack remote (GitHub URL or user/repo).
- `--remote-branch <name>`: Specific branch/tag/commit (default: repo's default).

## Configuration Options

- `-c, --config <path>`: Use custom config instead of repomix.config.json.
- `--init`: Create new repomix.config.json with defaults.
- `--global`: With --init, create in home directory.

## Security Options

- `--no-security-check`: Skip scanning for sensitive data (API keys, passwords).

## Token Count Options

- `--token-count-encoding <encoding>`: Tokenizer: o200k_base (default, GPT-4o), cl100k_base (GPT-3.5/4), etc.

## MCP Options

- `--mcp`: Run as Model Context Protocol server for AI integration.

## Help Options

- `-h, --help`: Display help.

## Command Examples

Translate intents to commands:

```bash
# Pack current directory
repomix

# Pack specific directories
repomix src/ docs/

# Pack remote repo
repomix --remote yamadashy/repomix

# Compress and markdown
repomix --compress --style markdown

# Include patterns and copy
repomix --include "src/**/*.ts,*.md" --copy

# Token tree with threshold
repomix --token-count-tree 100

# Include git diffs and logs
repomix --include-diffs --include-logs --include-logs-count 20
```

## Tips

- Use JSON for parsing: `repomix --style json | jq`.
- For large repos: Add --compress and --include.
- Chain with analysis: Pack first, then delegate to explorer agent.
- Config priority: Custom > repomix.config.json > defaults.
- Run `repomix --help` for latest options.
- Consult https://github.com/yamadashy/repomix for docs.
