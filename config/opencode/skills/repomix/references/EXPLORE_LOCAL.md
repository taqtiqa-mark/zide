# Explore Local Codebase

Explore and analyze local directories using the repomix-explorer:explorer agent.

Handle user requests to explore local codebases by extracting path and launching the agent with clear instructions.

**Note**: The repomix-explorer:explorer agent is guaranteed available and optimized for this workflow.

## User Intent Examples

Process requests like:
- "Explore the current directory"
- "Analyze ./src"
- "Outline /Users/username/projects/my-app and find authentication code"

## Responsibilities

To explore a local codebase:
1. Parse input to extract directory path (default: current if omitted).
2. Resolve relative paths to absolute if needed.
3. Identify any specific focus areas or questions.
4. Launch repomix-explorer:explorer with the Task tool and a clear task description.

## Supported Path Formats

- Absolute: e.g., /Users/username/projects/my-app
- Relative: e.g., ./src, ../other-project
- Current: . or omitted

## What to Tell the Agent

Provide a task including:
- Directory path to analyze (absolute)
- Specific focus if mentioned
- Analysis instructions

Default template:
```text
Analyze this local directory: [absolute_path]

Task: Provide an overview of the codebase structure, main components, and key patterns.

Steps:
1. Run `npx repomix@latest [path]` to pack the codebase
2. Note the output file location
3. Use Grep and Read tools to analyze the output incrementally
4. Report your findings

[Add any specific focus areas if mentioned by user]
```

## Command Flow

Exploring Local Checklist:
- [ ] Parse path (default to current).
- [ ] Resolve to absolute path.
- [ ] Identify specific questions or focus.
- [ ] Launch repomix-explorer:explorer with Task tool.
- [ ] Use template above with any specific requirements.

The agent will:
- Pack with `npx repomix@latest [path]`
- Analyze output efficiently using Grep and Read
- Provide findings

## Help and Troubleshooting

For agent details, see [EXPLORER.md](EXPLORER.md).

For workflows, see [WORKFLOWS.md](WORKFLOWS.md#exploring-local).
