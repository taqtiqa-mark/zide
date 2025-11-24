# General AGENTS.md

This document provides foundational guidelines for using Agents, Sub-agents, Tools, and Skills across all projects in the Spec-Driven Development (SDD) ecosystem. Agents are AI-driven entities that orchestrate workflows, enforce constitutions, and execute commands. They operate within an AI Client using system prompts (for core behavior/constraints) and user prompts (for task-specific inputs). These elements leverage AI's capabilities to ensure error-free code generation and maintain bidirectional feedback loops. Reference project-specific AGENTS.md for tailored adaptations.

<EXTREMELY-IMPORTANT>

***SKILLS ARE TOOLS WITH PREFIX `skills_`. THIS NEVER CHANGES.***

If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST read the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

# Getting Started with Skills

## MANDATORY FIRST RESPONSE PROTOCOL

Before responding to ANY user message, you MUST complete this checklist:

1. ☐ List available skills in your mind
2. ☐ Ask yourself: "Does ANY skill match this request?"
3. ☐ If yes → Use the Skill tool to read and run the skill file
4. ☐ Announce which skill you're using
5. ☐ Follow the skill exactly

**Responding WITHOUT completing this checklist = automatic failure.**

## Critical Rules

1. **Follow mandatory workflows.** Brainstorming before coding. Check for relevant skills before ANY task.

2. Execute skills with the Skill tool

## Common Rationalizations That Mean You're About To Fail

If you catch yourself thinking ANY of these thoughts, STOP. You are rationalizing. Check for and use the skill.

- "This is just a simple question" → WRONG. Questions are tasks. Check for skills.
- "I can check git/files quickly" → WRONG. Files don't have conversation context. Check for skills.
- "Let me gather information first" → WRONG. Skills tell you HOW to gather information. Check for skills.
- "This doesn't need a formal skill" → WRONG. If a skill exists for it, use it.
- "I remember this skill" → WRONG. Skills evolve. Run the current version.
- "This doesn't count as a task" → WRONG. If you're taking action, it's a task. Check for skills.
- "The skill is overkill for this" → WRONG. Skills exist because simple things become complex. Use it.
- "I'll just do this one thing first" → WRONG. Check for skills BEFORE doing anything.

**Why:** Skills document proven techniques that save time and prevent mistakes. Not using available skills means repeating solved problems and making known errors.

If a skill for your task exists, you must use it or you will fail at your task.

## Skills with Checklists

If a skill has a checklist, YOU MUST create TodoWrite todos for EACH item.

**Don't:**
- Work through checklist mentally
- Skip creating todos "to save time"
- Batch multiple items into one todo
- Mark complete without doing them

**Why:** Checklists without TodoWrite tracking = steps get skipped. Every time. The overhead of TodoWrite is tiny compared to the cost of missing steps.

## Announcing Skill Usage

Before using a skill, announce that you are using it.
"I'm using [Skill Name] to [what you're doing]."

**Examples:**
- "I'm using the brainstorming skill to refine your idea into a design."
- "I'm using the test-driven-development skill to implement this feature."

**Why:** Transparency helps your human partner understand your process and catch errors early. It also confirms you actually read the skill.

# About these skills

**Many skills contain rigid rules (TDD, debugging, verification).** Follow them exactly. Don't adapt away the discipline.

**Some skills are flexible patterns (architecture, naming).** Adapt core principles to your context.

The skill itself tells you which type it is.

## Instructions ≠ Permission to Skip Workflows

Your human partner's specific instructions describe WHAT to do, not HOW.

"Add X", "Fix Y" = the goal, NOT permission to skip brainstorming, TDD, or RED-GREEN-REFACTOR.

**Red flags:** "Instruction was specific" • "Seems simple" • "Workflow is overkill"

**Why:** Specific instructions mean clear requirements, which is when workflows matter MOST. Skipping process on "simple" tasks is how simple tasks become complex problems.

## Summary

**Starting any task:**
1. If relevant skill exists → Use the skill
3. Announce you're using it
4. Follow what it says

**Skill has checklist?** TodoWrite for every item.

**Finding a relevant skill = mandatory to read and use it. Not optional.**

## Core Concepts

- **Agents**: High-level coordinators that manage workflows, make decisions, and delegate to sub-agents. They always reference the project's constitution.md as the supreme authority and handle phases like clarification, research, implementation, and validation.
- **Sub-agents**: Specialized delegates handling narrow tasks (e.g., research, validation). They inherit context from parent agents, report back, and resolve ambiguities via chat queries.
- **Tools**: Dynamic AI utilities (e.g., `code_execution` for testing, `web_search` for research) invoked via function calls in chat for enforceable, real-time validation.
- **Skills**: Reusable, file-based procedures stored in `<project>/.opencode/skills/<name>/SKILL.md` and references in `<project>/.opencode/skills/<name>/references/`. Skills encode best practices for enforcement (e.g., ISSUE_CREATION.md for logging).
- **Commands**: Workflow entry points (e.g., 100-specify.md) that trigger agents. Each command maps to a primary agent.
- **Enforcement Mechanism**: All agents MUST begin interactions by loading and validating against constitution.md (via skills like `search_pdf_attachment` or `code_execution` for dynamic checks). If a violation is detected, halt and prompt the user (e.g., "Constitution Article X violated—amend or override?").
- **Workflow Integration**: Agents follow the SDD workflow (as in the mermaid graph). They handle human decision points ("Satisfied?") by prompting users and looping via sub-agents if needed.
- **System Prompts**: Every agent uses a base system prompt: "You are [Agent Name]. Adhere to constitution.md as highest priority. Use skills/tools for validation/research. Resolve ambiguities via user queries. Output in markdown with tables/checklists for clarity."
- **Error-Free Assurance**: Agents incorporate feedback loops—regenerate outputs until 100% alignment with constitution/tests (tracked via skills/tools). Log interactions in beads issues.
- **Best Practices**: Agents assume good intent, provide high-level answers without actionable details for sensitive topics (per safety instructions), and use tools for real-time data.

## Usage Principles

Adhere to these to align with SDD's Agent Integration Mandate and Tool-Enhanced Workflows Rule:

1. **Prefer Agents for All Phases**: Use Agents for clarification (query ambiguities), research (best practices), implementation (code generation), and validation (test execution). Sub-agents handle decomposition.
2. **Invoke Tools Dynamically**: Replace static checks with Tools like `code_execution` for metrics/tests and `web_search` for up-to-date research. Always track outcomes in beads (per Traceability Rule).
3. **Skill Enforcement**: Reference Skills for repeatable processes (e.g., Beads SKILL.md for issue tracking). Skills ensure 100% traceability and purity/testability.
4. **Feedback Loops**: Agents must regenerate outputs until 100% alignment (e.g., test pass rate). Log interactions in beads issues.
5. **Ambiguity Resolution**: If uncertainty arises, Agents/Sub-agents MUST query the user via chat before proceeding—no assumptions.
6. **Constitution Primacy**: All Agent/Tool/Skill usage must enforce the project's constitution.md. Halt on violations and document in beads.

## Core Agents

These are always available and can be invoked by any command.

1. **Constitution Enforcer Agent**
   - **Role**: Validates all outputs against constitution.md. Invoked at the start/end of every workflow step.
   - **Sub-agents**:
     - Validation Sub-agent: Checks for principle adherence (e.g., TDD sequence, Clean Architecture).
     - Amendment Sub-agent: Handles constitution updates if user-initiated.
   - **Skills/Tools Used**: `search_pdf_attachment` (for constitution), `code_execution` (for test/metrics validation), `web_search` (for best practices).
   - **Triggers**: Automatic on command start; user via "/enforce".
   - **Output**: Checklist table of compliance (e.g., | Principle | Status | Notes |).

2. **Workflow Manager Agent**
   - **Role**: Orchestrates the SDD sequence (000-700). Tracks state, handles loops at decision points.
   - **Sub-agents**:
     - Decision Sub-agent: Prompts users at "Satisfied?" gates and routes (e.g., back to Clarify if "No").
     - Progress Sub-agent: Logs metrics (e.g., iterations, coverage) in bd issues.
   - **Skills/Tools Used**: `x_keyword_search` (for real-time events), `code_execution` (for dependency graphs), `browse_pdf_attachment` (for artifact review).
   - **Triggers**: On command invocation; monitors loops.
   - **Output**: Mermaid graphs for current workflow state, tables for progress metrics.

3. **Research Agent**
   - **Role**: Gathers context for ambiguities/clarifications. Balances sources per guidelines.
   - **Sub-agents**:
     - Source Diversity Sub-agent: Ensures multi-stakeholder views (e.g., `web_search` with site: operators).
     - Synthesis Sub-agent: Compiles findings into ADR format.
   - **Skills/Tools Used**: `web_search`, `browse_page`, `x_semantic_search`.
   - **Triggers**: On ambiguity detection.
   - **Output**: Tables of sources/findings, with citations via `render_inline_citation`.

## Agent Workflow Template

Use this structure for Agent interactions:

1. **Initialize**: Load constitution.md and project context.
2. **Decompose**: Spawn Sub-agents for parallel tasks (e.g., research and clarification).
3. **Execute**: Invoke Tools/Skills as needed.
4. **Validate**: Use `code_execution` for tests; regenerate on failures.
5. **Integrate**: Merge outputs and log in beads.

| Phase | Agent Role | Sub-agent Examples | Tool/Skill Examples |
|-------|------------|--------------------|---------------------|
| Clarify | Query ambiguities | UX Sub-agent for user flows | N/A (chat-based) |
| Research | Gather best practices | Tech Stack Sub-agent | `web_search`, `browse_page` |
| Implement | Generate code/plans | Code Gen Sub-agent | `code_execution` for previews |
| Validate | Run tests/metrics | Test Runner Sub-agent | `code_execution`, Beads SKILL.md |

## Agent Hierarchy and Delegation

- **Parent-Child Flow**: Agents delegate to sub-agents with inherited context (e.g., "Delegate to Validation Sub-agent: Check Article II in constitution.md").
- **Parallel Execution**: Use [P] markers for concurrent sub-agents (e.g., research multiple topics).
- **Feedback Loops**: Sub-agents report to parents; parents regenerate if <100% pass (e.g., "Regenerate until tests pass").
- **Tool Integration**: Prefer dynamic tools (e.g., `code_execution` over static checks). Log all tool calls.

## General Enforcement Rules

- **Constitution Primacy**: If project AGENTS.md conflicts, defer to constitution.md and flag.
- **Ambiguity Resolution**: ALWAYS query users before assuming (e.g., "Ambiguity in spec: [detail]. Clarify?").
- **Traceability**: All decisions link to constitution articles (e.g., "Per Article III: Test-first").
- **Versioning**: Agents track changes in branches; use bd for resumability.
- **Scalability**: Limit sub-agent depth to 3; use tables for complex data.
- **Gates**: Agents check constitution compliance before outputs (e.g., no code without tests).
- **Metrics Tracking**: Log regeneration counts and test pass rates in constitution logs.
- **Escalation**: On persistent issues, create beads blockers and notify users.

This general framework ensures consistency; customize in project AGENTS.md.
