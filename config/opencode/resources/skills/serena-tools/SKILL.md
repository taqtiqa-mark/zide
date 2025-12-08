---
name: serena-tools
description: Use this skill when performing symbolic code operations like finding/renaming symbols, searching patterns, editing code bodies, inserting content, or managing project memories. It provides hierarchical workflows enforcing TDD for reliability and persuasion for adherence, optimized for token efficiency via progressive disclosure to detailed tool references.
---

# Serena Tools Automation Skill

## Overview

Automates Serena tools with TDD (RED-GREEN-REFACTOR) and persuasion principles (authority, commitment) for robust code manipulation. Organizes into meta/search/edit/memory hierarchies for progressive use. Benefits: 40% fewer errors via TDD, doubled compliance via persuasion (kb/insights.md). Trigger by announcing: "Using serena-tools for [task]".

## When to Use

- Symbolic operations: finding/editing symbols (use instead of full-file reads).
- Memory management: persisting project insights.
- Meta tasks: onboarding, thinking about adherence/completion.
- Not for: Non-code tasks (prefer native tools); always check hierarchies first.

## Tool Hierarchy

```mermaid
graph TD
    A[Meta Tools] --> B[Search Tools]
    B --> C[Edit Tools]
    C --> D[Memory Tools]
    A -->|Think/Plan| D
    subgraph Meta
        serena_activate_project
        serena_check_onboarding_performed
        serena_get_current_config
        serena_initial_instructions
        serena_onboarding
        serena_prepare_for_new_conversation
        serena_remove_project
        serena_restart_language_server
        serena_summarize_changes
        serena_switch_modes
        serena_think_about_collected_information
        serena_think_about_task_adherence
        serena_think_about_whether_you_are_done
    end
    subgraph Search
        serena_find_file
        serena_find_referencing_symbols
        serena_find_symbol
        serena_get_symbols_overview
        serena_list_dir
        serena_search_for_pattern
        serena_read_file
    end
    subgraph Edit
        serena_create_text_file
        serena_delete_lines
        serena_execute_shell_command
        serena_insert_after_symbol
        serena_insert_at_line
        serena_insert_before_symbol
        serena_rename_symbol
        serena_replace_symbol_body
    end
    subgraph Memory
        serena_delete_memory
        serena_edit_memory
        serena_list_memories
        serena_read_memory
        serena_write_memory
    end
```

See references/tool_references.md for tool summaries; full details in references/tool/[tool].md.

## General TDD Workflow

MANDATORY for operations (authority: collated_knowledge.md; skipping = 40% more errors). Commit to announcing phases (commitment principle).

1. **RED**: Validate current state fails (e.g., serena_get_symbols_overview).
2. **GREEN**: Minimal tool call to pass.
3. **REFACTOR**: Optimize, test loopholes (patterns.md).

## Common Rationalizations (Avoid These)

| Excuse | Reality |
|--------|---------|
| "Task too simple for TDD" | Simple tasks break; TDD takes seconds. |
| "I'll TDD after" | After = verification, not design. |
| "No time" | Skipping causes more time fixing errors. |
| "It's optional" | Mandatory per insights.md. |

## Task-Based Workflows (Summaries)

### Meta: Use before/after others for setup/thinking. E.g., serena_think_about_whether_you_are_done at end (authority: initial_instructions.md). Details: references/tool/[meta-tool].md.

### Search: Start with overview, then specifics. TDD: Assert no match (RED), call tool (GREEN). Restrict paths for efficiency. Details: references/tool/[search-tool].md.

### Edit: Search first, then edit. TDD: Assert old content (RED), apply (GREEN), validate references (REFACTOR). Details: references/tool/[edit-tool].md.

### Memory: List first, then operate. TDD: Assert incorrect (RED), write/edit (GREEN). Limit chars. Details: references/tool/[memory-tool].md.

## Resources

- **scripts/**: tdd_wrapper.sh (execute via bash).
- **references/**: best_practices.md, tool_references.md (summaries), persuasion.md, tdd_guide.md.
- **assets/**: hierarchy_diagram.dot, tdd_template.md.

Load as needed; see references/tool/[tool].md for tool-specifics.
