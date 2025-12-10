# Pack Remote Repository

Pack remote GitHub repositories into AI-optimized formats using repomix.

Handle user requests to pack remote repositories by parsing intent and executing the command with appropriate options.

## User Intent Examples

Process requests like:
- "Pack the yamadashy/repomix repository"
- "Analyze facebook/react from GitHub"
- "Pack https://github.com/microsoft/vscode"
- "Pack react repository with compression"
- "Pack only TypeScript files from the Next.js repo"
- "Analyze the main branch of user/repo"

## Responsibilities

To pack a remote repository:
1. Parse natural language to extract repository information (URL or owner/repo, branch/tag/commit if specified).
2. Select options based on intent.
3. Execute `npx repomix@latest --remote <repo> [options]` via Bash.

## Supported Repository Formats

- `owner/repo` (e.g., yamadashy/repomix)
- `https://github.com/owner/repo`
- `https://github.com/owner/repo/tree/branch-name`
- `https://github.com/owner/repo/commit/hash`

## Available Options

Refer to [CLI_REFERENCE.md](CLI_REFERENCE.md) for full details. Key options include:
- `--style <format>`: xml (default), markdown, json, plain
- `--include <patterns>`: e.g., "src/**/*.ts,**/*.md"
- `--ignore <patterns>`: Additional exclusions
- `--compress`: ~70% token reduction
- `--output <path>`: Custom path
- `--copy`: Clipboard copy

## Command Examples

Translate intents to commands:

```bash
# Pack basic repo
npx repomix@latest --remote yamadashy/repomix

# Pack full URL
npx repomix@latest --remote https://github.com/facebook/react

# Pack specific branch
npx repomix@latest --remote https://github.com/user/repo/tree/develop

# With compression
npx repomix@latest --remote microsoft/vscode --compress

# Specific files
npx repomix@latest --remote owner/repo --include "src/**/*.ts"

# Markdown and copy
npx repomix@latest --remote yamadashy/repomix --copy --style markdown
```

## Analyzing Output

Avoid direct full-file reads due to size. For analysis:
- Delegate to sub-agent (repomix-explorer:explorer preferred).
- Provide task: "Analyze [file]. Use Grep and Read incrementally. Overview structure and [focus]. Do NOT read entire file."

See [WORKFLOWS.md](WORKFLOWS.md#analysis-sub-agent) for checklist.

## Help and Troubleshooting

For options or issues:
- Run `npx repomix@latest --help`
- Consult https://github.com/yamadashy/repomix

For workflows, see [WORKFLOWS.md](WORKFLOWS.md#packing-remote).
