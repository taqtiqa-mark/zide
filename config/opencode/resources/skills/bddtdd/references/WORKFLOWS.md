# BDD-TDD Workflows

## Overview

This reference details step-by-step workflows for using the bdd-tdd skill, integrating BDD for behavior specification, TDD for implementation, and Bead for persistence and dependency management. Workflows ensure BDD-first sequencing, where Gherkin scenarios guide TDD cycles, minimizing pain points like ambiguous expectations (via clear acceptance criteria) and unstructured iterations (via enforced phases). Incorporate best practices such as collaborative scenario writing (involve stakeholders for clarity) and one concept per scenario (focus on single behaviors to avoid overload).

**Key Principles**:
- Start with BDD to define "what" (behaviors), then integrate TDD for "how" (code).
- Use Bead to enforce sequences, track discoveries, and survive compaction.
- Reference pain points from [PAIN_POINTS.md](PAIN_POINTS.md), e.g., dependencies prevent oversight by automating ready work.

## Contents

- [Session Start Workflow](#session-start) - Check Bead readiness and establish context
- [BDD Phase Workflow](#bdd-phase) - From user story to Gherkin generation and Bead epic creation
- [TDD Integration Workflow](#tdd-integration) - RED-GREEN-REFACTOR with Bead blocks dependencies
- [Handling Discoveries Workflow](#handling-discoveries) - Side quests via discovered-from dependencies
- [Multi-Session Resume Workflow](#multi-session-resume) - Compaction survival using notes
- [Monitoring Workflow](#monitoring) - Using Bead stats and ready for progress tracking
- [Common Workflow Patterns](#common-patterns) - Systematic exploration, bug investigation, etc.
- [Checklist Templates](#checklist-templates) - Reusable templates for key activities
- [Decision Points](#decision-points) - When to collaborate, ask user, etc.
- [Troubleshooting Workflows](#troubleshooting-workflows) - Common issues and fixes

## Session Start Workflow {#session-start}

At session start, check for Bead availability and surface ready work to establish context, minimizing context loss pain points.

**Bead is available when**:
- Project has `.beads/` directory (project-local), OR
- `~/.beads/` exists (global fallback).

**Session Start Checklist**:

```
Session Start:
- [ ] Run bd ready --json to identify unblocked BDD/TDD issues
- [ ] Run bd list --status in_progress --json for active work
- [ ] If in_progress issues exist: bd show <issue-id> to review notes and Gherkin/TDD status
- [ ] Report to user: "X items ready (e.g., BDD epics or TDD phases): [summary]"
- [ ] If using global ~/.beads, note this in report
- [ ] If nothing ready: bd blocked --json to identify blockers (e.g., unresolved BDD scenarios)
- [ ] Suggest next action: e.g., "Start BDD phase for new story?" or "Resume TDD green phase?"
```

**Pattern**: Always run `bd ready` to focus on unblocked work, preventing dependency oversights.

## BDD Phase Workflow {#bdd-phase}

Convert user stories to declarative Gherkin scenarios, store in Bead epics. Incorporate collaborative writing: involve user/stakeholders for review. Focus on one concept per scenario to minimize scope creep.

**BDD Phase Checklist** (Story to Gherkin and Bead Creation):

```
BDD Phase:
- [ ] Receive user story (e.g., "As a shopper, I want to add items...")
- [ ] Collaborate: Ask user for clarification on behaviors/outcomes; involve stakeholders if needed
- [ ] Generate Gherkin: Use scripts/generate_gherkin.py for declarative scenarios (one concept each, e.g., basic add vs. edge case)
- [ ] Review for best practices: Declarative? Concise? Behavior-focused?
- [ ] Create Bead epic: bd create "Feature Title" -t epic -d "As a... I want... so that..." --acceptance "Gherkin scenarios"
- [ ] Add tags/labels if needed (e.g., @smoke)
- [ ] Update notes: "Gherkin refined collaboratively; ready for TDD decomposition"
- [ ] If refinements needed: Iterate with user before proceeding
```

**Pattern**: BDD-first ensures behaviors guide TDD, reducing mismatched expectations. Reference [BDD_TDD_BEST_PRACTICES.md](BDD_TDD_BEST_PRACTICES.md) for syntax tips.

**Pain Point Minimization**: Clear Gherkin in `acceptance` field prevents ambiguity; collaborative step aligns expectations early.

## TDD Integration Workflow {#tdd-integration}

Decompose BDD scenarios into TDD phases using Bead hierarchies and blocks. Enforce RED-GREEN-REFACTOR to minimize unstructured iterations.

**TDD Integration Checklist** (RED-GREEN-REFACTOR with Dependencies):

```markdown
TDD Integration:
- [ ] From BDD epic: Decompose scenarios into child tasks (bd create "TDD for Scenario X" -t task --design "Initial notes")
- [ ] Link hierarchy: bd dep add epic-id child-id --type parent-child
- [ ] Enforce sequence: Create phase issues (e.g., red: "Write failing test", green: "Minimal code to pass", refactor: "Optimize")
- [ ] Add blocks: bd dep add red-id green-id --type blocks; bd dep add green-id refactor-id --type blocks
- [ ] RED: Write a failing unit test matching the Then outcomes (tests first); mark in_progress
- [ ] GREEN: Implement minimal code to make the test pass; verify test passes
- [ ] REFACTOR: Optimize while keeping tests green; update design notes
- [ ] Update Bead notes: "COMPLETED: Green phase - tests passing; KEY DECISION: Used pattern Y for Z"
- [ ] Close phases as done; bd ready shows next unblocked
```

**Pattern**: Blocks ensure tests-first adherence; parent-child links BDD behaviors to TDD units.

**Pain Point Minimization**: Phased dependencies prevent skipping steps, reducing iterations from failures.

## Handling Discoveries Workflow {#handling-discoveries}

During BDD/TDD, capture side quests (e.g., bugs) without derailing main flow, using discovered-from for provenance.

**Handling Discoveries Checklist**:

```
Handling Discoveries:
- [ ] During work: Notice bug, improvement, or follow-up (e.g., edge case in TDD)
- [ ] Assess: Blocker? (Yes: pause main; No: defer)
- [ ] Create issue: bd create "Discovered: Bug in X" -t bug
- [ ] Link: bd dep add current-id new-id --type discovered-from
- [ ] If blocker: Add blocks dep; switch to new issue
- [ ] Update notes on original: "DISCOVERY: Created issue for Y; context: Z"
- [ ] Resume main flow or use bd ready for next
```

**Pattern**: Discovered-from preserves context, minimizing context loss in multi-session work.

**Pain Point Minimization**: Tracks emergent scope without creep; dependencies automate surfacing when resolved.

## Multi-Session Resume Workflow {#multi-session-resume}

After compaction, recover via Bead notes, ensuring resumability for iterative BDD/TDD.

**Multi-Session Resume Checklist** (Compaction Survival):

```
Multi-Session Resume:
- [ ] Run bd list --status in_progress to find active BDD/TDD issues
- [ ] For each: bd show <issue-id> to read notes (e.g., COMPLETED, IN PROGRESS, BLOCKERS)
- [ ] Check dependencies: bd dep tree <issue-id> for BDD-TDD hierarchy
- [ ] If notes insufficient: bd list --status open for related/discovered issues
- [ ] Reconstruct: Regenerate Gherkin/TDD stubs if needed; ask user for confirmation
- [ ] Report to user: "Resuming from compaction: X in progress, next step Y"
- [ ] Proceed: Update status to in_progress and continue phase
```

**Pattern**: Detailed notes (e.g., "IN PROGRESS: Green phase - test for duplicates failing") enable full recovery.

**Pain Point Minimization**: Prevents rework from lost decisions; notes reference best practices like concise scenarios.

## Monitoring Workflow {#monitoring}

Track progress and identify bottlenecks using Bead commands.

**Monitoring Checklist**:

```
Monitoring:
- [ ] Run bd stats --json: Total issues, open/in_progress/closed, blocked/ready
- [ ] Run bd ready --json: Unblocked BDD epics or TDD phases
- [ ] Run bd blocked --json: Stuck items (e.g., TDD red blocked by BDD refinement)
- [ ] Report to user: "Progress: X% complete; bottlenecks: Y blocked by Z"
- [ ] If cycles detected: bd dep cycles
- [ ] Suggest actions: e.g., "Unblock by refining Gherkin?" or "Prioritize high-priority bugs"
```

**Pattern**: Regular stats prevent oversight; ready focuses effort on actionable items.

**Pain Point Minimization**: Identifies dependency issues early, reducing integration failures.

## Common Workflow Patterns {#common-patterns}

### Pattern: Systematic Exploration (Research-Intensive BDD)

```
1. Create BDD research epic with open questions
2. Generate initial Gherkin hypotheses
3. Decompose into TDD spikes (short experiments)
4. Link discoveries with discovered-from
5. Refine Gherkin based on findings; close epic with final scenarios
```

### Pattern: Bug Investigation (Iterative TDD)

```
1. Create bug issue from BDD failure
2. Reproduce in Gherkin (add scenario)
3. TDD: RED for failure, GREEN for fix, REFACTOR for cleanup
4. Update acceptance; close with root cause notes
```

### Pattern: Refactoring with Dependencies

```
1. Create BDD epic for refactored feature
2. Add child TDD tasks with blocks for order (e.g., schema before endpoints)
3. Work via bd ready; each close unblocks next
```

### Pattern: Collaborative Scenario Refinement

```
1. Generate draft Gherkin
2. Share with user/stakeholders for feedback
3. Iterate: Update acceptance field
4. Proceed to TDD only when approved
```

## Checklist Templates {#checklist-templates}

### Starting Any Session

```
- [ ] bd ready check
- [ ] Review in_progress notes
- [ ] Report status
- [ ] Choose BDD epic or TDD phase
```

### Creating BDD Scenarios

```
- [ ] User story input
- [ ] Collaborative clarification
- [ ] Generate declarative Gherkin (one concept/scenario)
- [ ] Bead epic creation
```

### Completing TDD Cycle

```
- [ ] RED: Failing test
- [ ] GREEN: Pass minimal
- [ ] REFACTOR: Optimize
- [ ] Close phase; check unblocked
```

### Planning Complex Features

```
- [ ] BDD epic creation
- [ ] Decompose scenarios to TDD children
- [ ] Add parent-child and blocks deps
- [ ] Work via dependency order
```

## Decision Points {#decision-points}

**Bead vs TodoWrite?** Complex/multi-session BDD/TDD → Bead; linear single-session TDD → TodoWrite (see [BOUNDARIES.md](BOUNDARIES.md)).

**Collaborate or Generate Directly?** Fuzzy stories → Ask user; clear behaviors → Generate and review.

**Blocker or Deferrable Discovery?** Prevents progress → Blocker (blocks dep); optional → Defer (related/discovered-from).

**Update Gherkin Mid-TDD?** Discovery changes behavior → Yes, refine acceptance; implementation detail → No, note in design.

**Monitor Frequency?** Start/end of sessions minimum; during long iterations if bottlenecks suspected.

## Troubleshooting Workflows {#troubleshooting-workflows}

**No Ready Work?**
1. bd blocked --json
2. Identify/resolve blockers (e.g., incomplete BDD)
3. Create new if no relevant issues

**Gherkin Not Triggering TDD?**
1. bd show epic-id
2. Check parent-child deps
3. Add if missing; bd ready refreshes

**Compaction Lost Context?**
1. bd show on in_progress
2. Use notes to reconstruct
3. Regenerate artifacts if needed

**Too Many Scenarios?**
1. Review for one concept each
2. Split features; use Outlines for variations

**Blocked by Cycles?**
1. bd dep cycles
2. Remove circular deps (e.g., wrong direction)
3. Re-sequence phases
