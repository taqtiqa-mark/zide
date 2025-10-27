# Workflows and Checklists (Checklists)

Reusable checklist templates and decision points for bd usage.

## Contents

- [Checklist Templates](#checklist-templates)
  - Starting Any Work Session
  - Creating Issues During Work
  - Completing Work
  - Planning Complex Features
- [Decision Points](#decision-points)

For core daily workflows, see [WORKFLOWS_CORE.md](WORKFLOWS_CORE.md).  
For advanced patterns, see [WORKFLOWS_ADVANCED.md](WORKFLOWS_ADVANCED.md).  
For error-handling, see [WORKFLOWS_TROUBLESHOOTING.md](WORKFLOWS_TROUBLESHOOTING.md).

## Checklist Templates {#checklist-templates}

Use these templates as starting points for common scenarios. Copy and adapt them during sessions to track progress.

### Starting Any Work Session

```
- [ ] Check for .beads/ directory
- [ ] If exists: bd ready
- [ ] Report status to user
- [ ] Get user input on what to work on
- [ ] Show issue details
- [ ] Update to in_progress
- [ ] Begin work
```

### Creating Issues During Work

```
- [ ] Notice new work needed
- [ ] Create issue with clear title
- [ ] Add context in description
- [ ] Link with discovered-from to current work
- [ ] Assess blocker vs deferrable
- [ ] Update statuses appropriately
```

### Completing Work

```
- [ ] Implementation done
- [ ] Tests passing
- [ ] Close issue with summary
- [ ] Check bd ready for unblocked work
- [ ] Report completion and next available work
```

### Planning Complex Features

```
- [ ] Create epic for overall goal
- [ ] Break into child tasks
- [ ] Create all child issues
- [ ] Link with parent-child dependencies
- [ ] Add blocks between children if order matters
- [ ] Work through in dependency order
```

## Decision Points {#decision-points}

Evaluate these questions to guide bd usage. Always consider boundaries first.

**Should I create a bd issue or use TodoWrite?**  
→ See [BOUNDARIES.md](BOUNDARIES.md) for decision matrix

**Should I ask user before creating issue?**  
→ Ask if scope unclear; create if obvious follow-up work

**Should I mark work as blocked or just note dependency?**  
→ Blocked = can't proceed; dependency = need to track relationship

**Should I create epic or just tasks?**  
→ Epic if 5+ related tasks; tasks if simpler structure

**Should I update status frequently or just at start/end?**  
→ Start and end minimum; during work if significant changes
