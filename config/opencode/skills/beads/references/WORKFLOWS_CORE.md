# Workflows and Checklists (Core)

Detailed step-by-step workflows for essential daily bd usage patterns with checklists. For advanced patterns, see [WORKFLOWS_ADVANCED.md](WORKFLOWS_ADVANCED.md); for reusable templates/decisions, see [WORKFLOWS_CHECKLISTS.md](WORKFLOWS_CHECKLISTS.md); for troubleshooting, see  [WORKFLOWS_TROUBLESHOOTING.md](WORKFLOWS_TROUBLESHOOTING.md).

## Contents

- [Session Start Workflow](#session-start) - Check bd ready, establish context
- [Compaction Survival](#compaction-survival) - Recovering after compaction events
- [Discovery and Issue Creation](#discovery) - Proactive issue creation during work
- [Status Maintenance](#status-maintenance) - Keeping bd status current
- [Epic Planning](#epic-planning) - Structuring complex work with dependencies
- [Side Quest Handling](#side-quests) - Discovery during main task, assessing blocker vs deferrable, resuming
- [Multi-Session Resume](#resume) - Returning after days/weeks away
- [Session Handoff Workflow](#session-handoff) - Collaborative handoff between sessions
- [Unblocking Work](#unblocking) - Handling blocked issues
- [Git Workflow Patterns](#git-workflow-patterns) - Version control integration
- [Integration with TodoWrite](#integration-with-todowrite) - Using both tools together
- [Summary Workflow](#summary-workflow) - High-level Summary Workflow
 
For advanced patterns, see [WORKFLOWS_ADVANCED.md](WORKFLOWS_ADVANCED.md).
For reusable templates, see [WORKFLOWS_CHECKLISTS.md](WORKFLOWS_CHECKLISTS.md).
For error-handling, see [WORKFLOWS_TROUBLESHOOTING.md](WORKFLOWS_TROUBLESHOOTING.md).

---

## Session Start Workflow {#session-start}

**bd is available when:**
- Project has a `.beads/` directory (project-local database), OR
- `~/.beads/` exists (global fallback database for any directory)

**At session start, bd auto-discovers which database to use. Then run ready check.**

### Session Start Checklist

Copy this checklist when starting any session where bd is available:

```
Session Start:
- [ ] Run bd ready --json to see available work
- [ ] Run bd list --status in_progress --json for active work
- [ ] If in_progress exists: bd show <issue-id> to read notes
- [ ] Report context to user: "X items ready: [summary]"
- [ ] If using global ~/.beads, mention this in report
- [ ] If nothing ready: bd blocked --json to check blockers
```

**Pattern**: Always check both `bd ready` AND `bd list --status in_progress`. Read notes field first to understand where previous session left off. Report status to establish shared context.

**Example: "Let's Continue" Protocol:**
For AI pairing like OpenCode, tell the AI: **"Let's continue"**. It runs:
```bash
bd ready --limit 5
bd show bd-X  # Top priority
```

**Report format**:
- "I can see X items ready to work on: [summary]"
- "Issue Y is in_progress. Last session: [summary from notes]. Next: [from notes]. Should I continue with that?"

This establishes immediate shared context about available and active work without requiring user prompting.

**For detailed collaborative handoff process, read:** [references/WORKFLOWS_CORE.md](references/WORKFLOWS_CORE.md#session-handoff)

**Note**: bd auto-discovers the database:
- Uses `.beads/*.db` in current project if exists
- Falls back to `~/.beads/default.db` otherwise
- No configuration needed

### When No Work is Ready

If `bd ready` returns empty but issues exist:

```bash
bd blocked --json
```

Report blockers and suggest next steps.

---

## Compaction Survival {#compaction-survival}

Recover context after compaction events, where conversation history is deleted but bd state persists.

**Critical**: After compaction, bd state is the only persistent memory. Compaction events delete conversation history but preserve beads.

**What survives compaction:**
- All bead data (issues, notes, dependencies, status)
- Complete work history and context

**What doesn't survive:**
- Conversation history
- TodoWrite lists
- Recent discussion context

**Post-compaction recovery checklist**:

```markdown
After Compaction:
- [ ] Run bd list --status in_progress to see active work
- [ ] Run bd show <issue-id> for each in_progress issue
- [ ] Read notes field to understand: COMPLETED, IN PROGRESS, BLOCKERS, KEY DECISIONS
- [ ] Check dependencies: bd dep tree <issue-id> for context
- [ ] If notes insufficient, check bd list --status open for related issues
- [ ] Reconstruct TodoWrite list from notes if needed
```

**Writing notes for post-compaction recovery:**

Write notes to enable full context recovery with zero conversation history.

**Pattern:**
- COMPLETED: Specific deliverables ("implemented JWT refresh endpoint + rate limiting")
- IN PROGRESS: Current state + next immediate step ("testing password reset flow, need user input on email template")
- BLOCKERS: What's preventing progress ("Customer table migration failed")
- KEY DECISIONS: Important context or user guidance

**Good note (enables recovery)**:

```bash
bd update issue-42 --notes "COMPLETED: User authentication - added JWT token generation with 1hr expiry, implemented refresh token endpoint using rotating tokens pattern. IN PROGRESS: Password reset flow. Email service integration working. NEXT: Need to add rate limiting to reset endpoint (currently unlimited requests). KEY DECISION: Using bcrypt with 12 rounds after reviewing OWASP recommendations, tech lead concerned about response time but benchmarks show <100ms."
```

**Bad note (insufficient for recovery)**:
```bash
bd update issue-42 --notes "Working on auth feature. Made some progress. More to do later."
```

The good note contains:
- Specific accomplishments (what was implemented/configured)
- Current state (which part is working, what's in progress)
- Next concrete step (not just "continue")
- Key context (team concerns, technical decisions with rationale)

After compaction: Run `bd show <issue-id>` to reconstruct full context from notes field.

---

## Discovery and Issue Creation {#discovery}

Create issues proactively during work to capture emerging tasks.

**Discovery checklist**:

```markdown
During Work:
- [ ] Notice new work (bug, feature, refactor)
- [ ] Assess: Multi-session? Dependencies? Use bd (see BOUNDARIES.md)
- [ ] Create issue: Clear title, description, priority, type
- [ ] Add context: Design notes, acceptance criteria
- [ ] Link: Use discovered-from to current issue
- [ ] Assess blocker: Add blocks if it prevents progress
- [ ] Update current issue status if blocked
```

Create issues immediately upon discovery to preserve context.

**Example: During feature implementation**:
Discover a bug in authentication.
```bash
bd create "Fix auth bug: Invalid token handling" -t bug -p 0 -d "Reproduce: Send expired token to /api/user" --design "Hypotheses: Middleware not catching errors" --acceptance "Test: Expired token returns 401"
bd dep add current-issue-id new-bug-id --type discovered-from
bd dep add new-bug-id current-issue-id --type blocks  # If it blocks progress
bd update current-issue-id --status blocked
```

---

## Status Maintenance {#status-maintenance}

Keep bd status current to reflect work progress accurately.

**Status update checklist**:

```markdown
During Session:
- [ ] Start work: bd update <id> --status in_progress
- [ ] Mid-session: Update notes with progress/decisions
- [ ] Pause/block: bd update <id> --status blocked --notes "Blocker: Waiting for user input"
- [ ] Complete: bd close <id> --reason "Implemented and tested"
- [ ] Check unblocked: bd ready after close
```

Update status at start, significant changes, and end. This ensures `bd ready` always shows accurate available work.

**Example: Mid-session update**:

```bash
bd update bd-3 --notes "COMPLETED: JWT implementation. IN PROGRESS: Middleware. BLOCKER: Need clarification on token expiry."
```

---

## Epic Planning {#epic-planning}

Structure complex work with dependencies for large features or projects.

**Epic planning checklist**:

```markdown
Planning Epic:
- [ ] Create epic: bd create "Epic: User Authentication" -t epic -p 1
- [ ] Break down: Create child tasks/issues
- [ ] Add hierarchies: Use parent-child dependencies
- [ ] Order execution: Add blocks for prerequisites
- [ ] Visualize: bd dep tree <epic-id>
- [ ] Check ready: bd ready shows starting points
```

**Example: E-commerce project kickoff**:

```bash
bd create "Set up Next.js project" -p 0 -t task
bd create "Design database schema" -p 0 -t task
bd create "Build authentication system" -p 1 -t feature
# ... more creates ...

bd dep add bd-4 bd-2  # API depends on schema
bd dep add bd-3 bd-2  # Auth depends on schema
# ... more deps ...

bd dep tree bd-7  # Visualize deploy dependencies
```

Output shows dependency tree, ensuring correct order.

---

## Side Quest Handling {#side-quests}

Handle discoveries during main task without losing context.

**Side quest checklist**:

```markdown
During Main Task:
- [ ] Discover side quest (e.g., related bug)
- [ ] Assess: Blocker or deferrable?
- [ ] Create issue: Link with discovered-from
- [ ] If blocker: Add blocks dep, update main to blocked
- [ ] If deferrable: Continue main task
- [ ] Resume: Use bd ready to pick up later
```

Pause main work only for true blockers.

**Example: Discovering blocker**:

During UI build (bd-5), discover API issue.

```bash
bd create "Fix API rate limiting" -t bug -p 0
bd dep add current-ui-id new-api-id --type discovered-from
bd dep add new-api-id current-ui-id --type blocks
bd update current-ui-id --status blocked --notes "Blocked by API issue"
bd ready  # Shows new bug as ready
```

---

## Multi-Session Resume {#resume}

Return to work after days/weeks with preserved context.

**Resume checklist**:

```markdown
Resuming Work:
- [ ] Check session start (bd ready)
- [ ] Review in_progress: bd list --status in_progress
- [ ] Show details: bd show <id> for notes/dependencies
- [ ] Reconstruct state: From notes (COMPLETED/IN PROGRESS)
- [ ] Update if needed: bd update <id> --status in_progress
- [ ] Proceed with ready work
```

bd persists context indefinitely via git-backed database.

**Example: After 2 weeks**:

```bash
bd ready  # Shows unblocked issues
bd show bd-3  # Review auth system notes
# Resume implementation
```

---

## Session Handoff Workflow {#session-handoff}

Hand off work between sessions or agents collaboratively.

**Handoff checklist**:

```markdown
End of Session:
- [ ] Update notes: Current state, next steps
- [ ] Set status: in_progress or blocked
- [ ] Commit db: git add .beads/project.db
- [ ] Report: "Handoff complete, ready work: [bd ready]"

Start of Next Session:
- [ ] Pull changes: git pull
- [ ] Follow session start checklist
```

Ensure notes enable seamless handoff.

**Example: End session**:

```bash
bd update bd-4 --notes "COMPLETED: Basic routes. NEXT: Add pagination."
bd update bd-4 --status in_progress
git add .beads/project.db
git commit -m "Handoff: API routes in progress"
```

---

## Unblocking Work {#unblocking}

Resolve blocked issues to enable progress.

**Unblocking checklist**:

```markdown
When Blocked:
- [ ] Identify blockers: bd blocked
- [ ] Prioritize: Work on highest priority blocker
- [ ] Complete blocker: bd close <blocker-id>
- [ ] Check cascade: bd ready shows newly unblocked
- [ ] Report: "Unblocked X issues"
```

Closing blockers automatically unblocks dependents.

**Example: Schema blocks auth**:

```bash
bd blocked  # Shows bd-3 blocked by bd-2
# Work on bd-2...
bd close bd-2 --reason "Schema complete"
bd ready  # Now includes bd-3
```

---

## Git Workflow Patterns {#git-workflow-patterns}

Integrate bd with version control for persistent tracking.

**Git integration checklist**:

```markdown
Git Workflow:
- [ ] Add .beads/ to repo: git add .beads/issues.jsonl
- [ ] Ignore cache: Add .beads/*.db to .gitignore
- [ ] After operations: Auto-sync to JSONL (5s debounce)
- [ ] After git pull: Auto-import from JSONL if newer
- [ ] Commit db changes: git commit -m "bd update: Closed bd-3"
```

bd syncs automatically with git for collaboration.

**Example: Auto-close from commits**:

In `.git/hooks/commit-msg`:

```bash
#!/bin/bash
COMMIT_MSG=$(cat $1)
if [[ $COMMIT_MSG =~ bd-([0-9]+) ]]; then
    ISSUE_ID="bd-${BASH_REMATCH[1]}"
    bd close "$ISSUE_ID" --reason "Auto-closed from commit: $(git rev-parse --short HEAD)"
fi
```

## Integration with TodoWrite {#integration-with-todowrite}

Use bd and TodoWrite together, each for its strengths.

**Integration checklist**:

```markdown
Combined Use:
- [ ] Strategic: Use bd for multi-session/dependencies
- [ ] Tactical: Use TodoWrite for single-session linear steps
- [ ] Transition: Mid-session if complexity emerges
- [ ] Sync: Copy TodoWrite to bd notes when transitioning
- [ ] Visible progress: Use TodoWrite within bd issues
```

bd provides structure; TodoWrite provides visible progress.

**Example: Transition mid-session**:

Start with TodoWrite for simple task. Discover complexity.
- Create bd issue with current context
- Note: "Discovered complexity during implementation"
- Add dependencies as discovered
- Continue with bd tracking

## Summary Workflow {#summary-workflow}

**The workflow:**

1. Brain dump all tasks → `bd create`
2. Map dependencies → `bd dep add`
3. Find ready work → `bd ready`
4. Work on it → `bd update --status in_progress`
5. Complete it → `bd close`
6. Commit database → `git add project.db`
7. Repeat

**The magic:**

- Database knows what's ready
- Git tracks your progress
- AI can query and update
- You never lose track of "what's next"

