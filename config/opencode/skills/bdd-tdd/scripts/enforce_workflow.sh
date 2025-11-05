#!/bin/bash

# enforce_workflow.sh
# Description: Enforces TDD workflow for a BDD epic in Bead by creating child phase issues (red, green, refactor)
# if they don't exist, adding blocks dependencies (red blocks green blocks refactor), and updating notes for resumability.
# Input: Bead issue ID for the BDD epic (e.g., epic-1)
# Dependencies: Requires bd CLI to be installed and available in PATH.
# Usage: ./enforce_workflow.sh <epic_id>

set -euo pipefail

# Function to display usage
usage() {
    echo "Usage: $0 <epic_id>"
    echo "Example: $0 epic-1"
    exit 1
}

# Check if epic_id provided
if [ $# -ne 1 ]; then
    usage
fi

EPIC_ID="$1"

# Validate if epic exists
if ! bd show "$EPIC_ID" &> /dev/null; then
    echo "Error: Epic ID '$EPIC_ID' does not exist."
    exit 1
fi

# Phase names and descriptions
RED_PHASE_TITLE="TDD Red Phase: Write Failing Test"
RED_PHASE_DESC="Write the failing unit test based on BDD scenario outcomes."
GREEN_PHASE_TITLE="TDD Green Phase: Minimal Implementation"
GREEN_PHASE_DESC="Implement minimal code to make the test pass."
REFACTOR_PHASE_TITLE="TDD Refactor Phase: Optimize Code"
REFACTOR_PHASE_DESC="Refactor the code while keeping tests green."

# Check for existing child phases (assuming type=task and linked via parent-child)
# Use bd list with filters; parse JSON for IDs
existing_children=$(bd list --json --type task | jq -r --arg epic "$EPIC_ID" '.[] | select(.dependencies[]? | .type == "parent-child" and .from_id == $epic) | .id')

# Function to create phase issue if not exists
create_phase_if_needed() {
    local title="$1"
    local desc="$2"
    local existing_id=$(bd list --json | jq -r --arg t "$title" '.[] | select(.title == $t) | .id')
    if [ -z "$existing_id" ]; then
        new_id=$(bd create "$title" -t task -d "$desc" --json | jq -r '.id')
        echo "Created new phase: $new_id ($title)"
        # Link as child
        bd dep add "$EPIC_ID" "$new_id" --type parent-child
        # Update notes for resumability
        bd update "$new_id" --notes "Resumability: COMPLETED: None; IN PROGRESS: Initial setup; BLOCKERS: None; NEXT: Write failing test."
    else
        new_id="$existing_id"
        echo "Existing phase found: $new_id ($title)"
   
    echo "$new_id"
}

# Create or get phases
RED_ID=$(create_phase_if_needed "$RED_PHASE_TITLE" "$RED_PHASE_DESC")
GREEN_ID=$(create_phase_if_needed "$GREEN_PHASE_TITLE" "$GREEN_PHASE_DESC")
REFACTOR_ID=$(create_phase_if_needed "$REFACTOR_PHASE_TITLE" "$REFACTOR_PHASE_DESC")

# Check for existing blocks dependencies
has_dep() {
    local from="$1"
    local to="$2"
    bd show "$to" --json | jq -e --arg f "$from" '.dependencies[] | select(.from_id == $f and .type == "blocks")' &> /dev/null
}

# Add blocks if not exist: red blocks green
if ! has_dep "$RED_ID" "$GREEN_ID"; then
    bd dep add "$RED_ID" "$GREEN_ID" --type blocks
    echo "Added blocks dep: $RED_ID -> $GREEN_ID"
fi

# green blocks refactor
if ! has_dep "$GREEN_ID" "$REFACTOR_ID"; then
    bd dep add "$GREEN_ID" "$REFACTOR_ID" --type blocks
    echo "Added blocks dep: $GREEN_ID -> $REFACTOR_ID"
fi

# Update epic notes for resumability
bd update "$EPIC_ID" --notes "Workflow enforced: TDD phases created/linked. Resumability: Start with bd ready to see unblocked phases (e.g., Red first)."

echo "Workflow enforced for epic $EPIC_ID."
echo "Phases: Red ($RED_ID) -> Green ($GREEN_ID) -> Refactor ($REFACTOR_ID)"
