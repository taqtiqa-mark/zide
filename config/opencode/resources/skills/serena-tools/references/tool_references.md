# Serena Tool References Summary

This file provides brief summaries of all Serena tools for progressive disclosure. For full details, including parameters, examples, and troubleshooting, see references/tool/[tool_name].md.

## Meta Tools
- **serena_activate_project**: Activates the project with the given name or path.
- **serena_check_onboarding_performed**: Checks whether project onboarding was already performed.
- **serena_get_current_config**: Print the current configuration of the agent, including the active and available projects, tools, contexts, and modes.
- **serena_initial_instructions**: Provides the 'Serena Instructions Manual', which contains essential information on how to use the Serena toolbox.
- **serena_onboarding**: Call this tool if onboarding was not performed yet.
- **serena_prepare_for_new_conversation**: Instructions for preparing for a new conversation. This tool should only be called on explicit user request.
- **serena_remove_project**: Removes a project from the Serena configuration.
- **serena_restart_language_server**: Use this tool only on explicit user request or after confirmation. It may be necessary to restart the language server if it hangs.
- **serena_summarize_changes**: Summarize the changes you have made to the codebase. This tool should always be called after you have fully completed any non-trivial coding task, but only after the think_about_whether_you_are_done call.
- **serena_switch_modes**: Activates the desired modes, like ["editing", "interactive"] or ["planning", "one-shot"].
- **serena_think_about_collected_information**: Think about the collected information and whether it is sufficient and relevant.
- **serena_think_about_task_adherence**: Think about the task at hand and whether you are still on track.
- **serena_think_about_whether_you_are_done**: Whenever you feel that you are done with what the user has asked for, it is important to call this tool.

## Search Tools
- **serena_find_file**: Finds non-gitignored files matching the given file mask within the given relative path.
- **serena_find_referencing_symbols**: Finds references to the symbol at the given `name_path`.
- **serena_find_symbol**: Retrieves information on all symbols/code entities (classes, methods, etc.) based on the given name path pattern.
- **serena_get_symbols_overview**: Use this tool to get a high-level understanding of the code symbols in a file.
- **serena_list_dir**: Lists files and directories in the given directory (optionally with recursion).
- **serena_search_for_pattern**: Offers a flexible search for arbitrary patterns in the codebase, including the possibility to search in non-code files.
- **serena_read_file**: Reads the given file or a chunk of it.

## Edit Tools
- **serena_create_text_file**: Write a new file or overwrite an existing file. Returns a message indicating success or failure.
- **serena_delete_lines**: Deletes the given lines in the file.
- **serena_execute_shell_command**: Execute a shell command and return its output.
- **serena_insert_after_symbol**: Inserts the given body/content after the end of the definition of the given symbol (via the symbol's location).
- **serena_insert_at_line**: Inserts the given content at the given line in the file, pushing existing content of the line down.
- **serena_insert_before_symbol**: Inserts the given content before the beginning of the definition of the given symbol (via the symbol's location).
- **serena_rename_symbol**: Renames the symbol with the given `name_path` to `new_name` throughout the entire codebase.
- **serena_replace_symbol_body**: Replaces the body of the symbol with the given `name_path`.

## Memory Tools
- **serena_delete_memory**: Delete a memory file.
- **serena_edit_memory**: Replaces content matching a regular expression in a memory.
- **serena_list_memories**: List available memories.
- **serena_read_memory**: Read the content of a memory file.
- **serena_write_memory**: Write some information (utf-8-encoded) about this project that can be useful for future tasks to a memory in md format.
