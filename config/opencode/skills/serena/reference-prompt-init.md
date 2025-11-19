Given you are an exceptional, world class expert at writing AI prompts, for LLM providers, such as Grok
And given you have expertise in preparing a prompt to generate reference files for Claude style Skills
And given you are preparing a prompt to create Serena Skill reference files
When the list of Serena Tools is from, !`serena tools list --all`:
 * `activate_project`: Activates a project based on the project name or path.
 * `check_onboarding_performed`: Checks whether project onboarding was already performed.
 * `create_text_file`: Creates/overwrites a file in the project directory.
 * `delete_lines`: Deletes a range of lines within a file.
 * `delete_memory`: Deletes a memory from Serena's project-specific memory store.
 * `edit_memory`:
 * `execute_shell_command`: Executes a shell command.
 * `find_file`: Finds files in the given relative paths
 * `find_referencing_symbols`: Finds symbols that reference the symbol at the given location (optionally filtered by t
 * `find_symbol`: Performs a global (or local) search for symbols with/containing a given name/substring (optionally f
 * `get_current_config`: Prints the current configuration of the agent, including the active and available projects, t
 * `get_symbols_overview`: Gets an overview of the top-level symbols defined in a given file.
 * `initial_instructions`: Provides instructions on how to use the Serena toolbox. Should only be used in settings where the system prompt is not read automatically by the client. NOTE: Some MCP clients (including Claude Desktop) do not read the system prompt automatically!
 * `insert_after_symbol`: Inserts content after the end of the definition of a given symbol.
 * `insert_at_line`: Inserts content at a given line in a file.
 * `insert_before_symbol`: Inserts content before the beginning of the definition of a given symbol.
 * `jet_brains_find_referencing_symbols`: Finds symbols that reference the given symbol
 * `jet_brains_find_symbol`: Performs a global (or local) search for symbols with/containing a given name/substring (o
 * `jet_brains_get_symbols_overview`: Retrieves an overview of the top-level symbols within a specified file
 * `list_dir`: Lists files and directories in the given directory (optionally with recursion).
 * `list_memories`: Lists memories in Serena's project-specific memory store.
 * `onboarding`: Performs onboarding (identifying the project structure and essential tasks, e.g. for testing or building).
 * `prepare_for_new_conversation`: Provides instructions for preparing for a new conversation (in order to continue with the necessary context).
 * `read_file`: Reads a file within the project directory.
 * `read_memory`: Reads the memory with the given name from Serena's project-specific memory store.
 * `remove_project`: Removes a project from the Serena configuration.
 * `rename_symbol`: Renames a symbol throughout the codebase using language server refactoring capabilities.
 * `replace_lines`: Replaces a range of lines within a file with new content.
 * `replace_regex`: Replaces content in a file by using regular expressions.
 * `replace_symbol_body`: Replaces the full definition of a symbol.
 * `restart_language_server`: Restarts the language server, may be necessary when edits not through Serena happen.
 * `search_for_pattern`: Performs a search for a pattern in the project.
 * `summarize_changes`: Provides instructions for summarizing the changes made to the codebase.
 * `switch_modes`: Activates modes by providing a list of their names
 * `think_about_collected_information`: Thinking tool for pondering the completeness of collected information.
 * `think_about_task_adherence`: Thinking tool for determining whether the agent is still on track with the current task.
 * `think_about_whether_you_are_done`: Thinking tool for determining whether the task is truly completed.
 * `write_memory`: Writes a named memory (for future reference) to Serena's project-specific memory store.
Then propose a prompt that evaluates this prompt template, looping over each `[<tool>]` in the list:
```markdown
Given your knowledge as an exceptional, world class programmer, debugger and software architect.
When you are more than 95% confident in your answer.
Then provide answers to the following questions:
- What are 3-5 specific, real-world scenarios where the [<tool>] tool would be used? For example, is it primarily for code navigation, refactoring, debugging, or something else? Please provide concrete user queries or tasks that would trigger it, like "Find all methods in this class" or "Locate the definition of this variable in a large codebase."
- Are there related tools or workflows that interact with [<tool>]? For instance, does it often chain with editing tools (e.g., rename_symbol or replace_body), or is it used standalone? If chained, what are typical sequences?
- What are common mistakes or edge cases when using [<tool>]? Based on the test suites, things like substring matching, depth levels, or absolute vs. relative paths seem important—can you share examples of how these have caused issues in practice?
- How does the tool behave with different programming languages? Are there language-specific quirks or best practices (e.g., handling nested classes in Java vs. functions in Python)?
- What output from [<tool>] is most useful for follow-up actions? For example, do users typically need the full symbol details (like location, kind, body), or just the name_path and relative_path for quick reference?
And then place all the answers in a file `./references/tool/[<tool>].md` using this template:
~~~markdown
## Tool: `tool`

## Real-World Scenarios for Using `tool`

[]

~~~
```

Example:

The prompt for the `find_symbol`
Given your knowledge as an exceptional, world class programmer, debugger and software architect.
When you are more than 95% confident in your answer.
Then provide answers to the following questions:
- What are 3-5 specific, real-world scenarios where the `find_symbol` tool would be used? For example, is it primarily for code navigation, refactoring, debugging, or something else? Please provide concrete user queries or tasks that would trigger it, like "Find all methods in this class" or "Locate the definition of this variable in a large codebase."
- Are there related tools or workflows that interact with `find_symbol`? For instance, does it often chain with editing tools (e.g., rename_symbol or replace_body), or is it used standalone? If chained, what are typical sequences?
- What are common mistakes or edge cases when using `find_symbol`? Based on the test suites, things like substring matching, depth levels, or absolute vs. relative paths seem important—can you share examples of how these have caused issues in practice?
- How does the tool behave with different programming languages? The test suites cover Python, Go, Java, etc.—are there language-specific quirks or best practices (e.g., handling nested classes in Java vs. functions in Python)?
- What output from `find_symbol` is most useful for follow-up actions? For example, do users typically need the full symbol details (like location, kind, body), or just the name_path and relative_path for quick reference?

---
name: reference-tool # Must match directory name
description: Execute the tool reference workflow using the tool template to generate skill reference artifacts.
model: xai/grok-4
agent: skill-creator
subtask: true
license: MIT
allowed-tools: 
  - read
  - write
  - edit
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run !`serena tools description --context oaicompat-agent $ARGUMENTS` from repo root and read output. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load context**: Read tool description. Load `./reference/tool-template.md` template (already copied).

3. **Execute plan workflow**: Follow the structure in `./reference/tool-template.md` template to:
   - Fill Technical Context (mark unknowns as "NEEDS CLARIFICATION")
   - Fill Constitution Check section from constitution
   - Evaluate gates (ERROR if violations unjustified)
   - Phase 0: Generate research.md (resolve all NEEDS CLARIFICATION)
   - Phase 1: Generate data-model.md, contracts/, quickstart.md
   - Phase 1: Update agent context by running the agent script
   - Re-evaluate Constitution Check post-design

4. **Stop and report**: Command ends after Phase 2 planning. Report branch, IMPL_PLAN path, and generated artifacts.

## Phases

### Phase 0: Outline & Research

1. **Extract unknowns from Technical Context** above:
   - For each NEEDS CLARIFICATION → research task
   - For each dependency → best practices task
   - For each integration → patterns task

2. **Generate and dispatch research agents**:

   ```text
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all NEEDS CLARIFICATION resolved

### Phase 1: Design & Contracts

**Prerequisites:** `research.md` complete

1. **Extract entities from feature spec** → `data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Generate API contracts** from functional requirements:
   - For each user action → endpoint
   - Use standard REST/GraphQL patterns
   - Output OpenAPI/GraphQL schema to `/contracts/`

3. **Agent context update**:
   - Run `.specify/scripts/bash/update-agent-context.sh opencode`
   - These scripts detect which AI agent is in use
   - Update the appropriate agent-specific context file
   - Add only new technology from current plan
   - Preserve manual additions between markers

**Output**: data-model.md, /contracts/*, quickstart.md, agent-specific file

## Key rules

- Use absolute paths
- ERROR on gate failures or unresolved clarifications
