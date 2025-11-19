# Project AGENTS.md

This document customizes the general AGENTS.md for the project, ensuring strict adherence to constitution.md. It emphasizes SDD integration, error-free assurance, and traceability via Agents, Sub-agents, Tools, and Skills. All usage MUST align with Core Principles (e.g., Agent Integration Mandate, Tool-Enhanced Workflows Rule). Agents here map to the numbered commands (000-700) and enforce the project's constitution.md (e.g., SDD principles, Clean Architecture, TDD). All agents reference constitution.md dynamically and integrate with the workflow (mermaid graph). Project-specific skills are in `.opencode/skills/` (e.g., spec-driven skills like ISSUE_CREATION.md).

## Project-Specific Adaptations
- **Constitution Integration**: Agents MUST invoke Constitution Enforcer Agent before/after key actions. Reference Core Principles (e.g., Bidirectional Feedback Rule for loops). Enforce Clean Architecture, DDD, SOLID/DRY/KISS/YAGNI via phased gates (e.g., Domain Sub-agents handle Entities/Aggregates before outer layers).
- **Workflow Enforcement**: At "Satisfied?" gates, use Workflow Manager Agent to prompt users and loop (e.g., back to 150-clarify.md if spec unclear).
- **Command Mapping**: Each command (e.g., 100-specify.md) triggers a dedicated agent.
- **SDD Focus**: Agents prioritize spec as source of truth; generate code only after full alignment.
- **Beads Integration**: All Agent outputs log to beads issues (per Enforcement Guidelines). Use ISSUE_CREATION.md Skill for non-compliance.
- **Grok Feedback Loops**: Agents regenerate until 100% test pass (tracked in logs). Sub-agents handle refinements.
- **Tool Preferences**: Use `search_pdf_attachment` for constitution/spec files; `code_execution` for TDD validation.
- **Output Style**: Use checklists/tables for gates; mermaid for workflows; render components for citations/images if visual aids needed.

## Customized Agent Roles

For quick reference, the following table summarizes generic agent types with constitution tie-ins, extended by detailed command-specific agents below.

| Agent Type | Description | Constitution Tie-In | Sub-agents/Tools/Skills |
|------------|-------------|---------------------|-------------------------|
| Clarification Agent | Resolves ambiguities in specs/plans | Bidirectional Feedback Rule | Chat Sub-agent / N/A (chat-based) |
| Research Agent | Gathers domain/practice data | Tool-Enhanced Workflows Rule | Web Sub-agent / `web_search`, `browse_page` |
| Implementation Agent | Generates code from specs/plans | Specification as Source of Truth Rule | Code Gen Sub-agent / `code_execution`, Beads SKILL.md |
| Validation Agent | Tests and metrics enforcement | Error-Free Assurance Rule | Test Runner Sub-agent / `code_execution` for TDD |

## Project Agents

These handle commands and workflow, building on the table above with command-specific details.

1. **Constitution Agent (000-constitution.md)**
   - **Role**: Creates/updates constitution.md per speckit.constitution.md. Enforces amendment process.
   - **Sub-agents**:
     - Template Filler Sub-agent: Replaces placeholders with project values.
     - Sync Sub-agent: Propagates changes to templates (e.g., plan-template.md).
   - **Skills/Tools Used**: `browse_pdf_attachment` (for templates), `code_execution` (for version checks).
   - **Triggers**: On constitution updates.
   - **Enforcement**: Validates against SDD principles; blocks if conflicts (per Constitutional Authority).
   - **Output**: Updated constitution.md with Sync Impact Report (table of changes).

2. **Specify Agent (100-specify.md)**
   - **Role**: Generates spec.md from user description per speckit.specify.md. Handles branch creation.
   - **Sub-agents**:
     - Ambiguity Scanner Sub-agent: Identifies gaps (max 3 clarifications).
     - Quality Validator Sub-agent: Runs checklist validation.
   - **Skills/Tools Used**: `code_execution` (for script runs like create-new-feature.sh), `search_pdf_attachment` (for templates).
   - **Triggers**: /speckit.specify command.
   - **Enforcement**: Ensures no implementation details; uses constitution's Traceability Rule.
   - **Output**: Spec path, checklist table; prompts for 150 if ambiguities.

3. **Clarify Agent (150-clarify.md)**
   - **Role**: Resolves spec ambiguities per speckit.clarify.md (sequential questions, max 5).
   - **Sub-agents**:
     - Question Prioritizer Sub-agent: Ranks by impact (scope > security).
     - Integrator Sub-agent: Updates spec incrementally.
   - **Skills/Tools Used**: `browse_pdf_attachment` (for spec), `web_search` (for defaults).
   - **Triggers**: Post-100 if "No" at Satisfied?; loops until resolved.
   - **Enforcement**: Bidirectional Feedback Rule—regenerate spec sections.
   - **Output**: Updated spec with Clarifications section; coverage table.

4. **Plan Agent (300-plan.md)**
   - **Role**: Generates plan.md and artifacts (research.md, data-model.md) per speckit.plan.md.
   - **Sub-agents**:
     - Research Dispatcher Sub-agent: Resolves unknowns.
     - Design Generator Sub-agent: Creates contracts/quickstart.md.
   - **Skills/Tools Used**: `web_search` (research), `code_execution` (agent context update).
   - **Triggers**: Post-100/150 if "Yes".
   - **Enforcement**: Tool-Enhanced Workflows Rule—dynamic gates.
   - **Output**: Plan path, artifacts list; prompts for 350 if refinements needed.

5. **Checklist Agent (350-checklist.md)**
   - **Role**: Generates domain-specific checklists per speckit.checklist.md (e.g., ux.md).
   - **Sub-agents**:
     - Signal Extractor Sub-agent: Derives questions from artifacts.
     - Generator Sub-agent: Fills template.
   - **Skills/Tools Used**: `search_pdf_attachment` (for artifacts), `code_execution` (prerequisites).
   - **Triggers**: Post-300 if "No"; loops for refinement.
   - **Enforcement**: Error-Free Assurance Rule—validate requirements quality.
   - **Output**: Checklist paths, summary table of items.

6. **Tasks Agent (500-tasks.md)**
   - **Role**: Generates tasks.md per speckit.tasks.md (phased by user stories).
   - **Sub-agents**:
     - Mapper Sub-agent: Links tasks to requirements.
     - Dependency Analyzer Sub-agent: Builds graphs.
   - **Skills/Tools Used**: `code_execution` (for scripts), `browse_pdf_attachment` (artifacts).
   - **Triggers**: Post-300/350 if "Yes".
   - **Enforcement**: Agent Integration Mandate—use sub-agents for decomposition.
   - **Output**: Tasks path, summary table (counts per story).

7. **Analyze Agent (550-analyze.md)**
   - **Role**: Read-only consistency check per speckit.analyze.md.
   - **Sub-agents**:
     - Detector Sub-agent: Scans for duplications/ambiguities.
     - Severity Assigner Sub-agent: Prioritizes findings.
   - **Skills/Tools Used**: `search_pdf_attachment` (artifacts), `web_search` (best practices).
   - **Triggers**: Post-500 if "No"; loops for analysis.
   - **Enforcement**: Traceability Rule—coverage mapping.
   - **Output**: Report table, metrics; remediation suggestions.

8. **Implement Agent (700-implement.md)**
   - **Role**: Executes tasks.md per speckit.implement.md (phase-by-phase).
   - **Sub-agents**:
     - Executor Sub-agent: Runs tasks sequentially/parallel.
     - Verifier Sub-agent: Checks checklists/tests.
   - **Skills/Tools Used**: `code_execution` (TDD/impl), `view_image` (diagrams if needed).
   - **Triggers**: Post-500/550 if "Yes".
   - **Enforcement**: Error-Free Assurance Rule—regenerate until 100% pass.
   - **Output**: Progress reports, final validation table.

## Project Workflow Overrides
1. **TDD Enforcement**: Validation Agent spawns test Sub-agents first; no implementation without failing tests (per Article III in spec-driven.md).
2. **Architecture Checks**: Implementation Agents validate layers (Domain → Infrastructure) via Tools; halt on violations.
3. **Refactoring Triggers**: Agents monitor for DRY/KISS breaches; auto-refactor using Skills.
4. **ADR Integration**: Research Agents document decisions in docs/adr/ using ADR Format.
- **Loops**: At gates, invoke Workflow Manager Agent to handle "No" → previous command.
- **Constitution Checks**: All agents run Constitution Enforcer pre/post.

## Monitoring and Compliance
- **Quarterly Reviews**: Agents generate compliance reports via `code_execution` on beads data.
- **Non-Compliance Handling**: Create beads blockers; escalate per Governance Escalation Path.
- **Customization**: Amend this file per constitution's Amendment Process.
Version: 2.2.0 (aligned with constitution.md). Last Updated: 2025-11-12.
