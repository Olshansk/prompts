---
description: Capture learnings from the current session and update AGENTS.md
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - LS
  - AskUserQuestion
---

# Session Commit

Analyze the current conversation to extract valuable learnings and update the project's AGENTS.md file.

## Instructions

### Step 1: Check for AGENTS.md

First, check if `AGENTS.md` exists in the project root.

**If AGENTS.md is missing**, initialize it:
1. Analyze the project structure (package.json, pyproject.toml, Cargo.toml, etc.)
2. Create `AGENTS.md` with:
   - Project name and brief description
   - Key directories and their purposes
   - Tech stack and dependencies
   - Any patterns you've observed during this session
   - Development workflow (build, test, lint commands)

**If AGENTS.md exists**, read it to understand current content.

### Step 2: Analyze Session Learnings

Review the conversation for:
- Coding patterns and preferences discovered
- Architecture decisions made
- Gotchas or pitfalls encountered
- Project conventions established
- Debugging insights
- Workflow preferences

### Step 3: Propose Updates (REQUIRES CONFIRMATION)

**IMPORTANT: Do NOT make any changes yet.**

Present the exact proposed changes to the user in a clear format:

1. Show what will be **added** (new sections, new bullet points)
2. Show what will be **modified** (existing content being updated)
3. Show the **location** in AGENTS.md where each change will go

Format the proposal clearly:
```
## Proposed Changes to AGENTS.md

### Additions:
- [Section: X] New bullet: "..."
- [New Section: Y] ...

### Modifications:
- [Section: Z] Change "old text" → "new text"
```

Then ask the user: **"Do you want me to apply these changes to AGENTS.md?"**

Wait for explicit confirmation before proceeding.

### Step 4: Apply Changes

**Only after user confirms**, apply the approved changes:
- Update AGENTS.md with the approved content
- Merge with existing content appropriately

### Step 5: Ensure CLAUDE.md Exists

Check if `CLAUDE.md` exists. If missing or different, create/update it with:

```markdown
# CLAUDE.md

⚠️ This file is intentionally minimal.

**Authoritative project instructions live in `AGENTS.md`.**

You must:

1. Open and follow `AGENTS.md` before doing any work.
2. Treat `AGENTS.md` as the single source of truth for all operations.
3. Update `AGENTS.md` (not this file) when guidelines/architecture/standards change.

➡️ Read now: [AGENTS.md](./AGENTS.md)
```

### Step 6: Offer AGENTS.md Review (Optional)

After changes are committed, ask the user:

**"Would you like me to review the entire AGENTS.md for cleanup opportunities?"**

If the user accepts, perform a comprehensive review checking for:

1. **Duplicates**: Same or near-identical instructions in multiple places
2. **Redundancy**: Overlapping guidance that could be consolidated
3. **Stale/deprecated content**: References to old patterns, removed files, or outdated practices
4. **Consolidation opportunities**: Related items scattered across sections that belong together
5. **Improvement opportunities**: Unclear instructions, missing context, or verbose content that could be tightened

**Review Process:**
1. Read the entire AGENTS.md carefully
2. Build a cleanup plan with specific findings for each category
3. Present the plan to the user showing:
   - What will be removed (with reason)
   - What will be consolidated (showing before/after)
   - What will be improved (showing before/after)
4. **Wait for explicit confirmation** before making any changes
5. Apply only the approved changes

**CRITICAL**: Never delete content without showing it to the user first. The goal is cleanup, not loss of information.

## Tips

- If no meaningful learnings in this session, say so - don't force updates
- Prefer bullet points over paragraphs in AGENTS.md
- Include specific file paths when referencing project structure
- Avoid duplicating information already in AGENTS.md
- When reviewing, err on the side of keeping content if unsure
