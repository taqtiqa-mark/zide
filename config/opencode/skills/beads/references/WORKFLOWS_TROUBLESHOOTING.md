# Workflows and Checklists (Troubleshooting)

Error-specific flows for common bd issues, enhanced with database fixes. Use these workflows to diagnose and resolve problems systematically.

## Contents

- [General Troubleshooting Workflows](#general-troubleshooting-workflows)
  - "I can't find any ready work"
  - "I created an issue but it's not showing in ready"
  - "Work is more complex than expected"
  - "I closed an issue but work isn't done"
  - "Too many issues, can't find what matters"
- [Database Troubleshooting](#database-troubleshooting)
  - Database locked
  - Corrupted database
  - Reset everything

For core daily workflows, see [WORKFLOWS_CORE.md](WORKFLOWS_CORE.md).  
For advanced patterns, see [WORKFLOWS_ADVANCED.md](WORKFLOWS_ADVANCED.md).  
For reusable templates, see [WORKFLOWS_CHECKLISTS.md](WORKFLOWS_CHECKLISTS.md).

## General Troubleshooting Workflows {#general-troubleshooting-workflows}

Resolve common workflow issues with these step-by-step processes.

**"I can't find any ready work"**  
No issues appear in `bd ready`, but work exists.  
1. Run `bd blocked` to list blocked issues.  
2. Identify blockers (e.g., dependencies or status).  
3. Resolve: Work on blockers or create new unblocked issues.  
4. Verify: Run `bd ready` again.  

**Example Scenario**: All issues blocked by setup.  
```bash
bd ready  # Output: No ready work
bd blocked
# Output:
📋 Blocked issues (3):
1. [P1] bd-3: Build auth (blocked by bd-2)
2. [P1] bd-4: Create API (blocked by bd-2)
3. [P2] bd-5: Build UI (blocked by bd-4)
```
Work on bd-2:  
```bash
bd update bd-2 --status in_progress
# ... complete work ...
bd close bd-2 --reason "Setup complete"
bd ready
# Output:
📋 Ready work (3):
1. [P0] bd-1: Next.js setup
2. [P1] bd-3: Build auth
3. [P1] bd-4: Create API
```

**"I created an issue but it's not showing in ready"**  
New issue exists but not ready.  
1. Run `bd show <issue-id>` to inspect details.  
2. Check dependencies field for blockers.  
3. If blocked, resolve blocker first.  
4. If incorrectly blocked, remove dependency with `bd dep remove`.  
5. Verify: Run `bd ready`.  

**Example Scenario**: Issue blocked unexpectedly.  
```bash
bd create "Add logging" -p 1 -t task  # Creates bd-8
bd ready  # bd-8 not shown
bd show bd-8
# Output:
Issue: bd-8 Add logging [P1] (open) task
Dependencies (blocks this issue):
  - bd-2: Design schema
```
Resolve:  
```bash
# If incorrect: bd dep remove bd-2 bd-8
# Or complete blocker: bd close bd-2
bd ready  # Now includes bd-8
```

**"Work is more complex than expected"**  
Task started with TodoWrite reveals dependencies.  
1. Transition from TodoWrite to bd mid-session.  
2. Create bd issue with current context in description/notes.  
3. Note: "Discovered complexity during implementation".  
4. Add dependencies as discovered.  
5. Continue with bd tracking; update status.  

**Example Scenario**: Simple refactor becomes multi-part.  
Start with TodoWrite:  
```
- [ ] Rename variables
- [ ] Update tests
```
Discover dependency on schema change.  
Transition:  
```bash
bd create "Refactor user model" -t refactor -p 1 -d "Started as simple rename; discovered schema dependency" --notes "Discovered complexity during implementation. COMPLETED: Variable rename. IN PROGRESS: Tests. BLOCKER: Schema update."
bd create "Update schema for user model" -t task -p 0
bd dep add new-schema-id refactor-id --type blocks
bd dep add refactor-id new-schema-id --type discovered-from
bd update refactor-id --status blocked
bd ready  # Shows schema as ready
```

**"I closed an issue but work isn't done"**  
Issue closed prematurely.  
1. Reopen with `bd update <id> --status open`.  
2. Or create new issue linking to closed one (related/discovered-from).  
3. Note what's still needed in new/old issue.  
4. Update dependencies if needed.  
5. Verify: Run `bd show` on affected issues.  

**Example Scenario**: Tests incomplete after close.  
```bash
bd close bd-6 --reason "Tests added"  # Mistake
# Realize more needed
bd update bd-6 --status open --notes "Reopened: Integration tests incomplete. Still needed: Edge case coverage."
# Or new issue:
bd create "Add integration tests" -t task -p 2
bd dep add bd-6 new-id --type related
```

**"Too many issues, can't find what matters"**  
Overwhelmed by issue volume.  
1. Use `bd list` with filters (e.g., `--priority 0 --type bug`).  
2. Use `bd ready` to focus on unblocked work.  
3. Consider closing old issues that no longer matter.  
4. Use labels for organization (e.g., `bd create ... -l "project:web"`).  
5. Archive if needed (see performance tips in ADVANCED).  

**Example Scenario**: Cluttered list.  
```bash
bd list  # Shows 50+ issues
bd list --status open --priority 0-1 --type feature
# Output: Filtered to 5 high-priority features
bd ready  # Focus: 2 unblocked
bd update old-id --status closed --reason "No longer relevant"
bd create "New task" -l "sprint:5"
bd list -l "sprint:5"  # Organized view
```

## Database Troubleshooting {#database-troubleshooting}

Handle SQLite-specific issues.

**Database locked**  
Another process holds the lock.  
```bash
# Identify process
lsof project.db
# Output example:
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
sqlite3 12345 user    4u   REG   8,1    1024 1234 project.db
```
Kill process or wait; retry command.

**Corrupted database**  
Integrity issues detected.  
```bash
# Check integrity
sqlite3 project.db "PRAGMA integrity_check;"
# Output if corrupt: *** in database main ***
# On page 2 rowid 1: invalid rowid
# Recover
sqlite3 project.db ".dump" | sqlite3 recovered.db
mv recovered.db project.db
```

**Reset everything**  
Start fresh (data loss warning).  
```bash
rm ~/.beads/beads.db
bd create "Fresh start" -p 1
# Output: Created bd-1: Fresh start
```
