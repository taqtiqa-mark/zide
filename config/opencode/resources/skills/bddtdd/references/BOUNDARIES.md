# Boundaries: When to Use Bead vs TodoWrite in BDD/TDD

This reference provides detailed decision criteria for choosing between Bead issue tracking and TodoWrite for task management in BDD and TDD workflows, adapted from the Bead BOUNDARIES.md. It emphasizes using Bead for persistent, structured tracking of behaviors and tests, while TodoWrite handles immediate, linear steps.

## Contents

- [The Core Question](#the-core-question)
- [Decision Matrix](#decision-matrix)
  - [Use Bead for](#use-bead-for): Multi-Session BDD/TDD, Complex Dependencies, Exploratory Behaviors, Side Quests, Project Memory
  - [Use TodoWrite for](#use-todowrite-for): Single-Session Cycles, Linear Phases, Immediate Context, Simple Tracking
- [Detailed Comparison](#detailed-comparison)
- [Integration Patterns](#integration-patterns)
  - Pattern 1: Bead as Strategic, TodoWrite as Tactical
  - Pattern 2: TodoWrite as Working Copy of Bead
  - Pattern 3: Transition Mid-Session
- [Real-World Examples](#real-world-examples)
  - Strategic Feature Development (e.g., E-Commerce Cart), Simple TDD Cycle, Bug Investigation with Discoveries, Refactoring Scenarios
- [Common Mistakes](#common-mistakes)
  - Using TodoWrite for Multi-Session BDD, Using Bead for Simple Phases, Not Transitioning on Complexity, Creating Too Many Bead Issues, Never Using Bead
- [The Transition Point](#the-transition-point)
- [Summary Heuristics](#summary-heuristics)

## The Core Question

**"Could I resume this BDD/TDD work after 2 weeks away?"**

- If Bead would help resume (e.g., via persistent Gherkin scenarios and phase dependencies) → **use Bead**
- If markdown skim would suffice (e.g., for a quick RED-GREEN cycle) → **TodoWrite is fine**

This heuristic captures the essential difference: Bead provides structured context for iterative BDD refinements and TDD phases across long gaps, while TodoWrite excels at immediate session tracking.

## Decision Matrix

### Use Bead for:

#### Multi-Session Work
BDD/TDD spanning multiple compaction cycles or days where scenarios or tests need refinement over time.

**Examples:**
- Feature development with iterative Gherkin reviews across sessions
- TDD cycles split by research or stakeholder feedback
- BDD scenario outlining requiring experimentation over days
- Architecture decisions in TDD evolving through iterations

**Why Bead wins**: Issues capture Gherkin in `acceptance` and TDD notes in `design` that survive compaction. Return weeks later and see full history, behaviors, and phase status.

#### Complex Dependencies
BDD/TDD with blockers, prerequisites, or hierarchical structure (e.g., scenarios depending on prior tests).

**Examples:**
- BDD epic for OAuth with dependent TDD tasks for endpoints and units
- Research-heavy BDD with parallel scenario threads
- TDD refactoring with dependencies between behaviors
- Migration TDD requiring sequential BDD validation

**Why Bead wins**: Dependency graph shows what's blocking (e.g., BDD refinement blocks TDD red). `bd ready` automatically surfaces unblocked phases. No manual tracking required.

#### Knowledge Work
Tasks with fuzzy boundaries, exploration, or strategic thinking in BDD/TDD.

**Examples:**
- BDD scenario design requiring trade-off research per best practices
- TDD optimization with measurement across behaviors
- Gherkin refinement for ambiguous user stories
- TDD for performance with edge cases per scenarios

**Why Bead wins**: `design` and `acceptance` fields capture evolving Gherkin and test understanding. Issues can be refined as exploration reveals more.

#### Side Quests
Exploratory BDD/TDD that might pause the main flow (e.g., discoveries during scenario testing).

**Examples:**
- During TDD, discover better Gherkin pattern worth exploring
- While validating BDD, notice related behavioral bug
- During TDD review, identify scenario improvement
- While writing tests, find edge case requiring BDD update

**Why Bead wins**: Create issue with `discovered-from` dependency, pause main safely. Context preserved for both tracks. Resume either later.

#### Project Memory
Need to resume BDD/TDD after significant time with full context.

**Examples:**
- Iterative BDD across sprints
- Part-time TDD with irregular schedule
- Complex scenarios split across features
- Research BDD with long validation periods

**Why Bead wins**: Git-backed database persists indefinitely. All Gherkin, decisions, and history available on resume. No relying on conversation scrollback or markdown files.

---

### Use TodoWrite for:

#### Single-Session Tasks
BDD/TDD that completes within current conversation.

**Examples:**
- Writing a single Gherkin scenario from clear spec
- Fixing a TDD failure with known root cause
- Adding unit tests for a defined behavior
- Refining a concise scenario per feedback

**Why TodoWrite wins**: Simple checklist perfect for linear execution. No need for persistence or dependencies. Clear completion within session.

#### Linear Execution
Straightforward step-by-step phases with no branching.

**Examples:**
- RED-GREEN-REFACTOR for a single test
- Gherkin validation checklist
- TDD style cleanup
- Scenario updates following a guide

**Why TodoWrite wins**: Steps predetermined and sequential. No discovery, no blockers, no side quests. Just execute top to bottom.

#### Immediate Context
All information already in conversation.

**Examples:**
- User provides complete story and asks for Gherkin
- Bug with reproduction and TDD approach
- Scenario request with clear before/after
- Phase changes based on user prefs

**Why TodoWrite wins**: No external context to track. Everything needed in current conversation. TodoWrite provides user visibility, nothing more needed.

#### Simple Tracking
Just need a checklist to show progress to user.

**Examples:**
- Breaking down TDD into visible steps
- Showing BDD review progress
- Demonstrating systematic scenario approach
- Providing reassurance on phase execution

**Why TodoWrite wins**: User wants to see thinking and progress. TodoWrite visible in conversation. Bead invisible background structure.

---

## Detailed Comparison

| Aspect | Bead | TodoWrite |
|--------|-----|-----------|
| **Persistence** | Git-backed, survives compaction | Session-only, lost on compaction |
| **Structure** | Issues with fields (e.g., acceptance for Gherkin), dependencies (blocks for phases) | Simple checklists, no relationships |
| **Complexity Handling** | Dependencies for hierarchies (BDD epic to TDD children), ready/blocked tracking | Linear lists only, no automation |
| **Resumability** | Notes for compaction survival (e.g., "IN PROGRESS: TDD green") | Relies on markdown scrollback |
| **Visibility** | Background; user sees reports via bd ready/stats | Inline in conversation for progress |
| **Use Case Fit** | Multi-session BDD/TDD with iterations | Single-session linear phases |
| **Integration** | Strategic overview (epics/phases) | Tactical execution (step-by-step) |

## Integration Patterns

### Pattern 1: Bead as Strategic, TodoWrite as Tactical
Use Bead for overall BDD/TDD structure, TodoWrite for executing individual phases.

**Example**:
- Bead epic tracks BDD scenarios and TDD dependencies
- TodoWrite handles RED steps within a session

**Why this works**: Bead ensures behaviors guide tests; TodoWrite provides visible progress without overhead.

### Pattern 2: TodoWrite as Working Copy of Bead
Extract Bead acceptance/design into TodoWrite for session work, update Bead on completion.

**Example**:
- Pull Gherkin from Bead epic
- Use TodoWrite to refine steps
- Push updates back to Bead notes

**Why this works**: Combines persistence with immediate visibility.

### Pattern 3: Transition Mid-Session
Start with TodoWrite for "simple" BDD/TDD, transition to Bead on complexity.

**Example**:
- Begin TDD cycle in TodoWrite
- Discover dependency → Create Bead issue, link phases

**Why this works**: Handles emergent scope without initial overhead.

## Real-World Examples

### Example 1: Strategic Feature Development (E-Commerce Cart as Bead Epic)

**Scenario**: Develop "Add to Cart" with multiple scenarios and TDD phases.

**Why Bead**:
- Dependencies: BDD epic blocks TDD children (e.g., schema before tests)
- Multi-session: Refine Gherkin over reviews
- Potential side quest: Discover duplicate handling
- Track scenarios in acceptance

**TodoWrite role**: Use for linear GREEN phase steps.

**Why this works**: Bead prevents forgetting scenarios; `bd ready` shows next phase.

### Example 2: Simple TDD Cycle

**Scenario**: Implement unit test for a single behavior.

**Why TodoWrite**:
- Completes in session
- Linear: RED → GREEN → REFACTOR
- No dependencies or discoveries

**Bead role**: None needed unless scales.

**Why this works**: Quick visibility without persistence overhead.

### Example 3: Bug Investigation with Discoveries

**Scenario**: Fix login bug, discover edge case.

**Why Bead**:
- Discovered-from for new scenario
- Multi-session if research needed
- Update acceptance with refined Gherkin

**TodoWrite role**: Initial reproduction steps.

**Why this works**: Bead tracks provenance, minimizes loss.

### Example 4: Refactoring Scenarios

**Scenario**: Refactor Gherkin for clarity.

**Why Bead**:
- Hierarchical: Epic for feature, children for scenarios
- Dependencies if order matters

**TodoWrite role**: Checklist for single refactor.

**Why this works**: Bead automates unblocking refined tests.

## Common Mistakes

### Mistake 1: Using TodoWrite for Multi-Session BDD

**What happens**:
- Next session, forget Gherkin refinements
- Scroll history to reconstruct
- Lose behavioral decisions
- Duplicate scenarios

**Solution**: Create Bead epic. Persist acceptance across sessions.

### Mistake 2: Using Bead for Simple Linear Phases

**What happens**:
- Overhead of issues not justified
- User can't see progress inline
- Extra tool for no benefit

**Solution**: Use TodoWrite. Designed for this case.

### Mistake 3: Not Transitioning When Complexity Emerges

**What happens**:
- Start TodoWrite for "simple" TDD
- Discover blockers mid-way
- Keep TodoWrite despite poor fit
- Lose context on end

**Solution**: Transition to Bead on signal. Not too late mid-session.

### Mistake 4: Creating Too Many Bead Issues

**What happens**:
- Every tiny phase gets an issue
- Database cluttered
- Hard to find meaningful behaviors

**Solution**: Reserve Bead for work benefiting from persistence. Use "2 week test."

### Mistake 5: Never Using Bead Because TodoWrite is Familiar

**What happens**:
- Iterative BDD becomes markdown mess
- Lose track of scenario dependencies
- Can't resume TDD effectively
- Rotten partial Gherkin

**Solution**: Use Bead for next multi-session flow. Experience organization difference.

## The Transition Point

Most BDD/TDD starts with an implicit model:

**"This looks straightforward"** → TodoWrite

**As work progresses:**

✅ **Stays straightforward** → Continue TodoWrite, complete in session

⚠️ **Complexity emerges** → Transition to Bead, preserve context

Recognize the transition point:

**Transition signals:**
- "This BDD needs more scenarios than expected"
- "Discovered a TDD blocker"
- "Gherkin requires research"
- "Should pause and validate behavior first"
- "Session might end before completion"
- "Found related issues in TDD"

**On notice**: Create Bead issue, preserve Gherkin/tests, work from structured foundation.

## Summary Heuristics

Quick decision guides:

**Time horizon:**
- Same session → TodoWrite
- Multiple sessions → Bead

**Dependency structure:**
- Linear phases → TodoWrite
- Blockers/hierarchies → Bead

**Scope clarity:**
- Well-defined → TodoWrite
- Exploratory → Bead

**Context complexity:**
- Conversation has everything → TodoWrite
- External refinements needed → Bead

**User interaction:**
- Watching progress → TodoWrite visible
- Background structure → Bead invisible

**Resume difficulty:**
- Easy from markdown → TodoWrite
- Need structured history → Bead

When in doubt: **Use the 2-week test**. If resuming after 2 weeks without Bead would struggle, use Bead.
