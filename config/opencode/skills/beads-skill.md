---
name: beads
description: Track complex, multi-session work with dependency graphs using bd (beads) issue tracker. Use when work spans multiple sessions, has complex dependencies, or requires persistent context across compaction cycles. For simple single-session linear tasks, TodoWrite remains appropriate. Teaches the LLM model the patterns, philosophy, and decision-making for effective beads usage.
---

# bd Issue Tracking

## Overview

bd is a graph-based issue tracker for persistent memory across sessions. Use for multi-session work with complex dependencies; use TodoWrite for simple single-session tasks.

## When to Use bd vs TodoWrite

### Use bd when:
- **Multi-session work** - Tasks spanning multiple compaction cycles or days
- **Complex dependencies** - Work with blockers, prerequisites, or hierarchical structure
- **Knowledge work** - Strategic documents, research, or tasks with fuzzy boundaries
- **Side quests** - Exploratory work that might pause the main task
- **Project memory** - Need to resume work after weeks away with full context

### Use TodoWrite when:
- **Single-session tasks** - Work that completes within current session
- **Linear execution** - Straightforward step-by-step tasks with no branching
- **Immediate context** - All information already in conversation
- **Simple tracking** - Just need a checklist to show progress

**Key insight**: If resuming work after 2 weeks would be difficult without bd, use bd. If the work can be picked up from a markdown skim, TodoWrite is sufficient.

### Test Yourself: bd or TodoWrite?

Ask these questions to decide:

**Choose bd if:**
- ❓ "Will I need this context in 2 weeks?" → Yes = bd
- ❓ "Could conversation history get compacted?" → Yes = bd
- ❓ "Does this have blockers/dependencies?" → Yes = bd
- ❓ "Is this fuzzy/exploratory work?" → Yes = bd

**Choose TodoWrite if:**
- ❓ "Will this be done in this session?" → Yes = TodoWrite
- ❓ "Is this just a task list for me right now?" → Yes = TodoWrite
- ❓ "Is this linear with no branching?" → Yes = TodoWrite

**When in doubt**: Use bd. Better to have persistent memory than lose context.

For detailed decision criteria and integration patterns, see [references/BOUNDARIES.md](references/BOUNDARIES.md).

## Dependency Types (Quick Reference)

bd supports four dependency types:

| Type | Purpose | Affects Ready? | Example |
|------|---------|----------------|---------|
| **blocks** | Hard blocker, prerequisite | Yes | Schema blocks API implementation |
| **related** | Soft link, context | No | Similar features |
| **parent-child** | Hierarchy, epic/subtask | No | Epic contains tasks |
| **discovered-from** | Provenance, side quest | No | Bug found during feature work |

Only `blocks` prevents work from being ready. Use directional: `bd dep add blocker-id blocked-id`.

For deep understanding of types and patterns, see [references/DEPENDENCIES.md](references/DEPENDENCIES.md).

## Issue Creation Guidelines

Create issues proactively during discovery.

**Guidelines:**
- Clear, specific titles
- Detailed description with context
- Use --design for plans/hypotheses
- Use --acceptance for verification criteria
- Add labels for organization (-l)
- Link to existing work

**When to ask user first:**
- Unclear scope
- Potential duplicates
- Large epics
- Major changes

For full guidance on asking vs creating, quality, and criteria, see [references/ISSUE_CREATION.md](references/ISSUE_CREATION.md).

## Workflows

Follow core daily workflows for essential usage; reference advanced patterns as needed.

- For essential daily workflows (session start, discovery, epic planning, etc.), see [references/WORKFLOWS_CORE.md](references/WORKFLOWS_CORE.md)
- For specialized patterns (vibe coding, scripting, multi-project, common scenarios), see [references/WORKFLOWS_ADVANCED.md](references/WORKFLOWS_ADVANCED.md)
- For reusable checklist templates and decision points, see [references/WORKFLOWS_CHECKLISTS.md](references/WORKFLOWS_CHECKLISTS.md)
- For error-handling and troubleshooting, see [references/WORKFLOWS_TROUBLESHOOTING.md](references/WORKFLOWS_TROUBLESHOOTING.md)

## CLI Quick Reference

| Command | Purpose | Key Flags |
|---------|---------|-----------|
| `bd ready` | Find unblocked work | `--json`, `--limit` |
| `bd create` | New issue | `-t type`, `-p priority`, `-d desc` |
| `bd update` | Edit issue | `--status`, `--notes` |
| `bd close` | Complete issue | `--reason` |
| `bd show` | Details | `--json` |
| `bd list` | Filter issues | `--status`, `--type` |
| `bd dep add` | Add dep | `--type` (blocks/related/etc.) |
| `bd dep tree` | Visualize |  |

For complete command reference and examples, see [references/CLI_REFERENCE.md](references/CLI_REFERENCE.md).

## JSON Output

Add `--json` to commands for structured output.

**Example:**
```bash
bd ready --json | jq '.[0].id'
```

Parse results programmatically or extract specific fields.

## Troubleshooting

**If bd command not found:**
- Check installation: `bd version`
- Verify PATH includes bd binary location

**If issues seem lost:**
- Use `bd list` to see all issues
- Filter by status: `bd list --status closed`
- Closed issues remain in database permanently

**If bd show can't find issue by name:**
- `bd show` requires issue IDs, not issue titles
- Workaround: `bd list | grep -i "search term"` to find ID first
- Then: `bd show issue-id` with the discovered ID
- For glossaries/reference databases where names matter more than IDs, consider using markdown format alongside the database

**If dependencies seem wrong:**
- Use `bd show issue-id` to see full dependency tree
- Use `bd dep tree issue-id` for visualization
- Dependencies are directional: `bd dep add from-id to-id` means from-id blocks to-id
- See [references/DEPENDENCIES.md](references/DEPENDENCIES.md#common-mistakes)

**If database seems out of sync:**
- bd auto-syncs JSONL after each operation (5s debounce)
- bd auto-imports JSONL when newer than DB (after git pull)
- Manual operations: `bd export`, `bd import`

For more troubleshooting workflows, see [references/WORKFLOWS_TROUBLESHOOTING.md](references/WORKFLOWS_TROUBLESHOOTING.md).

## Reference Files

Detailed information organized by topic:

| Reference | Read When |
|-----------|-----------|
| [references/BOUNDARIES.md](references/BOUNDARIES.md) | Need detailed decision criteria for bd vs TodoWrite, or integration patterns |
| [references/CLI_REFERENCE.md](references/CLI_REFERENCE.md) | Need complete command reference, flag details, or examples |
| [references/DEPENDENCIES.md](references/DEPENDENCIES.md) | Need deep understanding of dependency types or relationship patterns |
| [references/ISSUE_CREATION.md](references/ISSUE_CREATION.md) | Need guidance on when to ask vs create issues, issue quality, or design vs acceptance criteria |
| [references/STATIC_DATA.md](references/STATIC_DATA.md) | Want to use bd for reference databases, glossaries, or static data instead of work tracking |
| [references/WORKFLOWS_CORE.md](references/WORKFLOWS_CORE.md) | Need essential daily workflows with checklists |
| [references/WORKFLOWS_ADVANCED.md](references/WORKFLOWS_ADVANCED.md) | Need specialized patterns for AI pairing, scripting, etc. |
| [references/WORKFLOWS_CHECKLISTS.md](references/WORKFLOWS_CHECKLISTS.md) | Need reusable checklist templates or decision points |
| [references/WORKFLOWS_TROUBLESHOOTING.md](references/WORKFLOWS_TROUBLESHOOTING.md) | Need error-handling and troubleshooting workflows
