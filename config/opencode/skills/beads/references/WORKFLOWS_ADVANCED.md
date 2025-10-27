# Workflows and Checklists (Advanced)

Specialized patterns for advanced bd usage, including AI pairing, scripting, multi-project handling, and complex workflows.

## Contents

- [Vibe Coding Protocol](#vibe-coding-protocol) - AI-assisted development sessions
- [Advanced Scripting Patterns](#advanced-scripting-patterns) - Automation and reporting
- [Multi-Project Management](#multi-project-management) - Handling multiple databases or labels
- [Common Workflow Patterns](#common-workflow-patterns)
  - Systematic Exploration
  - Bug Investigation
  - Refactoring with Dependencies
  - Spike Investigation

For core daily workflows, see [WORKFLOWS_CORE.md](WORKFLOWS_CORE.md).  
For reusable templates, see [WORKFLOWS_CHECKLISTS.md](WORKFLOWS_CHECKLISTS.md).  
For error-handling, see [WORKFLOWS_TROUBLESHOOTING.md](WORKFLOWS_TROUBLESHOOTING.md).

## Vibe Coding Protocol {#vibe-coding-protocol}

Pair with AI assistants like Claude Code for collaborative development.

**Protocol checklist**:

```
Vibe Coding Session:
- [ ] Start: Run "Let's Continue" protocol
- [ ] Plan: Create issues and map dependencies
- [ ] Execute: Update status, work on ready issues
- [ ] Visualize: Check dep tree for context
- [ ] Complete: Close issues, check unblocked work
```

**"Let's Continue" Protocol** (start every session):  
```bash
# 1. Check for abandoned work
bd list --status in_progress

# 2. If none, get ready work
bd ready --limit 5

# 3. Show top priority
bd show bd-X
```

Tell AI: **"Let's continue"** to trigger these commands.

**Full Project Workflow Example** (e-commerce project):  

#### Session 1: Project Kickoff  
AI creates issues:  
```bash
cd ~/my-project
alias bd="~/src/bd/bd --db ./project.db"

bd create "Set up Next.js project" -p 0 -t task
bd create "Design database schema" -p 0 -t task
bd create "Build authentication system" -p 1 -t feature
bd create "Create API routes" -p 1 -t feature
bd create "Build UI components" -p 2 -t feature
bd create "Add tests" -p 2 -t task
bd create "Deploy to production" -p 3 -t task
```

Map dependencies:  
```bash
bd dep add bd-4 bd-2  # API depends on schema
bd dep add bd-3 bd-2  # Auth depends on schema
bd dep add bd-5 bd-4  # UI depends on API
bd dep add bd-6 bd-3  # Tests depend on auth
bd dep add bd-6 bd-5  # Tests depend on UI
bd dep add bd-7 bd-6  # Deploy depends on tests
```

Visualize:  
```bash
bd dep tree bd-7
```

Output:  
```
🌲 Dependency tree for bd-7:

→ bd-7: Deploy to production [P3] (open)
  → bd-6: Add tests [P2] (open)
    → bd-3: Build authentication system [P1] (open)
      → bd-2: Design database schema [P0] (open)
    → bd-5: Build UI components [P2] (open)
      → bd-4: Create API routes [P1] (open)
        → bd-2: Design database schema [P0] (open)
```

Check ready work:  
```bash
bd ready
```

Output:  
```
📋 Ready work (2 issues with no blockers):

1. [P0] bd-1: Set up Next.js project
2. [P0] bd-2: Design database schema
```

#### Session 2: Foundation  
AI runs:  
```bash
bd ready  # Shows: bd-1, bd-2
```

Work on bd-2:  
```bash
bd update bd-2 --status in_progress
bd show bd-2

# ... designs schema, creates migrations ...

bd close bd-2 --reason "Schema designed with Prisma, migrations created"
bd ready
```

Now shows:  
```
📋 Ready work (3 issues):

1. [P0] bd-1: Set up Next.js project
2. [P1] bd-3: Build authentication system  ← Unblocked!
3. [P1] bd-4: Create API routes
```

## Advanced Scripting Patterns {#advanced-scripting-patterns}

Automate bd with scripts for reporting, hooks, and data management.

**Scripting checklist**:

```
Advanced Scripting:
- [ ] Identify repetition: Reporting, hooks, exports
- [ ] Create script: Bash/Python for automation
- [ ] Integrate: Git hooks or scheduled runs
- [ ] Test: Verify output and error handling
```

**Git Hook Example** (auto-close issues on commit):  
In `.git/hooks/commit-msg`:  
```bash
#!/bin/bash
COMMIT_MSG=$(cat $1)
if [[ $COMMIT_MSG =~ bd-([0-9]+) ]]; then
    ISSUE_ID="bd-${BASH_REMATCH[1]}"
    bd close "$ISSUE_ID" --reason "Auto-closed from commit: $(git rev-parse --short HEAD)"
fi
```

**Weekly Report Script**:  
```bash
#!/bin/bash
echo "Issues closed this week:"
sqlite3 project.db "
    SELECT id, title, closed_at
    FROM issues
    WHERE closed_at > date('now', '-7 days')
    ORDER BY closed_at DESC;
"
```

**Export/Import Patterns**:  
Export issues to JSON:  
```bash
sqlite3 project.db -json "SELECT * FROM issues;" > backup.json
```

Export dependency graph (DOT for Graphviz):  
```bash
sqlite3 project.db "
    SELECT 'digraph G {'
    UNION ALL
    SELECT '  \"' || issue_id || '\" -> \"' || depends_on_id || '\";'
    FROM dependencies
    UNION ALL
    SELECT '}';
" > graph.dot

dot -Tpng graph.dot -o graph.png
```

**Performance Optimization Scripts**:  
Vacuum database:  
```bash
sqlite3 project.db "VACUUM;"
```

Add custom indexes:  
```bash
sqlite3 project.db "CREATE INDEX idx_labels_custom ON labels(label) WHERE label LIKE 'project:%';"
```

Archive old issues:  
```bash
sqlite3 project.db "
    DELETE FROM issues
    WHERE status = 'closed'
    AND closed_at < date('now', '-6 months');
"
```

## Multi-Project Management {#multi-project-management}

Handle multiple projects with separate databases or labels.

**Management checklist**:

```
Multi-Project:
- [ ] Choose approach: Separate dbs or labels
- [ ] Create issues: Specify db or add labels
- [ ] Filter: Use sqlite queries or bd list
- [ ] Switch contexts: Alias bd for each project
```

**Separate Databases**:  
```bash
# Personal projects
bd --db ~/personal.db create "Task"

# Work projects
bd --db ~/work.db create "Task"

# Client A
bd --db ~/clients/client-a.db create "Task"
```

**Labels Approach**:  
```bash
bd create "Task" -l "project:website"
bd create "Task" -l "project:mobile-app"

# Filter by project
sqlite3 ~/.beads/beads.db "
    SELECT i.id, i.title
    FROM issues i
    JOIN labels l ON i.id = l.issue_id
    WHERE l.label = 'project:website';
"
```

## Common Workflow Patterns {#common-workflow-patterns}

Structured approaches for specific development scenarios.

### Pattern: Systematic Exploration

```
1. Create exploration issue: "Explore auth patterns"
2. Document findings in design field
3. Create child issues for promising paths
4. Link with parent-child
5. Add blocks if sequential
6. Work through ready paths
```

### Pattern: Bug Investigation

```
1. Create bug issue with reproduction steps
2. Add acceptance criteria: "Fix verified in staging"
3. Reproduce: confirm in description
4. Investigate: track hypotheses in design field
5. Fix: implement solution
6. Test: verify in acceptance criteria
7. Close with explanation of root cause and fix
```

### Pattern: Refactoring with Dependencies

```
1. Create issues for each refactoring step
2. Add blocks dependencies for correct order
3. Work through in dependency order
4. bd ready automatically shows next step
5. Each completion unblocks next work
```

### Pattern: Spike Investigation

```
1. Create spike issue: "Investigate caching options"
2. Time-box exploration
3. Document findings in design field
4. Create follow-up issues for chosen approach
5. Link follow-ups with discovered-from
6. Close spike with recommendation
```
