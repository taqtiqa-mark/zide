---
name: bdd-tdd
description: Use when implementing features via BDD for behaviors and TDD for units, tracking with Bead for persistence and dependencies - minimizes iterations from story to code by enforcing workflows and handling discoveries.
---

# BDD-TDD Skill

## Overview

Integrate BDD to define behaviors in Gherkin, guide TDD for unit implementation, and use Bead to track persistence and dependencies. Position BDD as the higher-level framework: generate scenarios first to establish acceptance, then decompose into TDD RED-GREEN-REFACTOR cycles. Employ Bead hierarchies (parent-child for BDD epics over TDD tasks) and blocks (for phase sequencing) to enforce workflows, handle discoveries, and ensure resumability, reducing pain points like mismatched expectations and context loss.

## When to Use

Trigger this skill on user queries providing stories or features requiring behavior specification and test-driven code (e.g., "Implement user login" or "Fix cart addition bug"). Apply for complex flows with multiple scenarios, dependencies, or multi-session iterations.

Differentiate from TodoWrite: Reserve Bead for complex/multi-session BDD/TDD (e.g., feature with multiple scenarios needing dependency tracking); employ TodoWrite for linear/single-session phases (e.g., simple TDD cycle without blockers). Test with the 2-week heuristic: if resumption after 2 weeks requires structured history, use Bead. For detailed criteria, integration patterns, and mistakes, consult [references/BOUNDARIES.md](references/BOUNDARIES.md).

## Core Workflows

Follow BDD-first: define behaviors, then integrate TDD phases with dependencies.

Generate Gherkin from user story by applying declarative syntax, concise structure, and outcome-focused grammar. Reference [references/BDD_TDD_BEST_PRACTICES.md] for examples. Output 1-2 scenarios (basic + edge).


Initiate BDD phase: Receive user story, collaborate for clarification, generate declarative Gherkin from user story by applying declarative syntax, concise structure, and outcome-focused grammar  (apply [assets/gherkin_template.feature](assets/gherkin_template.feature) for structure), focusing on one concept per scenario per [references/BDD_TDD_BEST_PRACTICES.md](references/BDD_TDD_BEST_PRACTICES.md). Output 1-2 scenarios (basic + edge).

Create Bead epic: Run bd create "Feature Title" -t epic -d "As a... I want... so that..." --acceptance "Gherkin scenarios".

Decompose for TDD integration: Create child tasks, link with parent-child dependencies (bd dep add epic-id child-id --type parent-child).

Enforce RED-GREEN-REFACTOR: Generate stubs with scripts/tdd_cycle_stub.py (use [assets/tdd_template.py](assets/tdd_template.py)), create phase issues, add blocks (bd dep add red-id green-id --type blocks), and execute using scripts/enforce_workflow.sh.

Handle resumption: On session start, run bd ready --json, review notes via bd show, and proceed to unblocked phases.

For detailed checklists and patterns, reference [references/WORKFLOWS.md](references/WORKFLOWS.md).

## Surviving Compaction

Prepare notes for recovery: Update Bead issues with structured notes (e.g., "COMPLETED: Green phase; IN PROGRESS: Refactor; BLOCKERS: Edge case scenario"). On resumption, run bd list --status in_progress, bd show <issue-id>, and bd dep tree to reconstruct Gherkin and TDD context. Regenerate artifacts if needed using scripts. This minimizes context loss per [references/PAIN_POINTS.md](references/PAIN_POINTS.md#context-loss-in-multi-session-or-collaborative-work).

## Issue Creation

Create issues proactively: For BDD, use acceptance for Gherkin (declarative, concise per best practices); for TDD, use design for phase notes and stubs.

Assess before creating: Ask user on fuzzy scopes (e.g., multiple scenario approaches); create directly for clear bugs or discoveries.

Employ types (epic for BDD features, task/bug for TDD phases) and priorities (0 for critical behaviors).

Link with discovered-from for side quests.

## Monitoring

Track progress: Run bd stats --json for totals and velocities; bd ready --json for unblocked phases; bd blocked --json for bottlenecks (e.g., stalled BDD refinements). Report to user with suggestions (e.g., "Unblock TDD by refining Gherkin"). Detect cycles with bd dep cycles. This identifies oversights early per [references/PAIN_POINTS.md](references/PAIN_POINTS.md#dependency-oversights-leading-to-out-of-order-development).

## Advanced

Assign types: epic for BDD features, task for TDD phases, bug for discoveries.

Set priorities: 0 (critical behaviors), 1 (high-impact tests), 2 (normal), 3 (low refinements).

Use bulk operations: bd close multiple phases on completion.

## Troubleshooting

Address no ready work: Run bd blocked, resolve BDD/TDD blockers.

Fix dependency issues: Run bd dep tree, adjust directions (prerequisite blocks dependent).

Handle compaction loss: Rely on notes; regenerate Gherkin/TDD with scripts.

Mitigate scope creep: Enforce checklists from [references/WORKFLOWS.md](references/WORKFLOWS.md), split overloaded scenarios.

For pain point-specific fixes, see [references/PAIN_POINTS.md](references/PAIN_POINTS.md).
