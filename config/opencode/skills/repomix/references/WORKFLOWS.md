# Workflows and Checklists

Detailed step-by-step workflows for common repomix usage patterns with checklists.

## Contents

- [Packing Local Codebase](#packing-local)
- [Packing Remote Repository](#packing-remote)
- [Exploring Local Codebase](#exploring-local)
- [Exploring Remote Repository](#exploring-remote)
- [Analysis with Sub-Agent](#analysis-sub-agent)
- [Error Handling Workflow](#error-handling)
- [Checklist Templates](#checklist-templates)

## Packing Local Codebase {#packing-local}

Pack a local directory into an AI-friendly file.

Packing Local Checklist:
- [ ] Parse path (default: current if omitted) and options (e.g., --compress, --include).
- [ ] Resolve relative to absolute path if needed.
- [ ] If git history requested, add --include-diffs or --include-logs.
- [ ] Run `npx repomix@latest [path] [options]`.
- [ ] Note output file location.
- [ ] If --copy, confirm clipboard.
- [ ] If analysis follows, proceed to exploration.

## Packing Remote Repository {#packing-remote}

Pack a GitHub repository.

Packing Remote Checklist:
- [ ] Extract repo (owner/repo or URL format).
- [ ] Handle branch/tag if specified.
- [ ] If git history requested, add --include-diffs or --include-logs.
- [ ] Run `npx repomix@latest --remote [repo] [options]`.
- [ ] Note output file.
- [ ] Proceed to analysis if requested.

## Exploring Local Codebase {#exploring-local}

Analyze a local directory's structure and content.

Exploring Local Checklist:
- [ ] Extract path and focus (e.g., "find authentication code").
- [ ] Pack if not already: `npx repomix@latest [path]`.
- [ ] Launch repomix-explorer:explorer with Task tool.
- [ ] Provide template: "Analyze [path]. Task: Overview of structure. Steps: 1. Pack with repomix. 2. Grep/Read output. 3. Report. [focus]".

## Exploring Remote Repository {#exploring-remote}

Analyze a GitHub repository.

Exploring Remote Checklist:
- [ ] Extract repo and focus.
- [ ] Pack: `npx repomix@latest --remote [repo]`.
- [ ] Launch repomix-explorer:explorer.
- [ ] Provide template: "Analyze [repo]. Task: Overview. Steps: 1. Pack. 2. Analyze output. [focus]".

## Analysis with Sub-Agent {#analysis-sub-agent}

Delegate incremental analysis.

Analysis Checklist:
- [ ] Confirm output file exists.
- [ ] Select agent: repomix-explorer:explorer preferred.
- [ ] Task: "Analyze [file]. Use Grep for patterns, Read for sections. Provide [overview/patterns/metrics]. Do NOT read entire file.".
- [ ] Report agent findings.

## Error Handling Workflow {#error-handling}

Error Checklist:
- [ ] If command fails: Verify URL/path, permissions.
- [ ] Large file: Add --compress or --include.
- [ ] No results: Broaden grep; check tree.
- [ ] Suggest: Run `npx repomix@latest --help`.

## Checklist Templates

### General Packing

- [ ] Intent: Pack [local/remote] with [options].
- [ ] Execute command.
- [ ] Verify output.

### General Exploration

- [ ] Intent: Analyze [focus].
- [ ] Pack codebase.
- [ ] Delegate analysis.
- [ ] Summarize findings.
