# Explore Remote Repository

Explore and analyze remote GitHub repositories using the repomix-explorer:explorer agent.

Handle user requests to explore remote repositories by extracting information and launching the agent with clear instructions.

**Note**: The repomix-explorer:explorer agent is guaranteed available and optimized for this workflow.

## User Intent Examples

Process requests like:
- "Explore the yamadashy/repomix repository"
- "Analyze https://github.com/facebook/react"
- "Outline microsoft/vscode and show the main architecture"

## Responsibilities

To explore a remote repository:
1. Parse input to extract repository information (owner/repo or URL format).
2. Identify any specific focus areas or questions.
3. Launch repomix-explorer:explorer with the Task tool and a clear task description.

## Supported Repository Formats

- `owner/repo` (e.g., yamadashy/repomix)
- `https://github.com/owner/repo`
- `https://github.com/owner/repo/tree/branch-name`

## What to Tell the Agent

Provide a task including:
- Repository to analyze
- Specific focus if mentioned
- Analysis instructions

Default template:
```text
Analyze this remote repository: [repo]

Task: Provide an overview of the repository structure, main components, and key patterns.

Steps:
1. Run `npx repomix@latest --remote [repo]` to pack the repository
2. Note the output file location
3. Use Grep and Read tools to analyze the output incrementally
4. Report your findings

[Add any specific focus areas if mentioned by user]
```

## Command Flow

Exploring Remote Checklist:
- [ ] Parse repository information (owner/repo or full URL).
- [ ] Identify specific questions or focus areas.
- [ ] Launch repomix-explorer:explorer with Task tool.
- [ ] Use template above with any specific requirements.

The agent will:
- Pack with `npx repomix@latest --remote <repo>`
- Analyze output efficiently using Grep and Read
- Provide findings

## Help and Troubleshooting

For agent details, see [EXPLORER.md](EXPLORER.md).

For workflows, see [WORKFLOWS.md](WORKFLOWS.md#exploring-remote).
