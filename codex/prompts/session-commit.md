---
description: Capture learnings from the current session and update`AGENTS.md`
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

# Session Commit <!-- omit in toc -->

Analyze the current conversation to extract best practices and/or valuable learnings to the project's`AGENTS.md` file. This is a mechanism to scale your human/agent team.

- [Instructions](#instructions)
  - [Step 1: Ensure CLAUDE.md, GEMINI.md, and CODEX.md Exist](#step-1-ensure-claudemd-geminimd-and-codexmd-exist)
  - [Step 2: Check for `AGENTS.md`](#step-2-check-for-agentsmd)
  - [Step 3: Comprehensive `AGENTS.md` Analysis (MANDATORY)](#step-3-comprehensive-agentsmd-analysis-mandatory)
  - [Step 4: Analyze Session Learnings](#step-4-analyze-session-learnings)
  - [Step 5: Propose Updates with Visual Formatting (REQUIRES CONFIRMATION)](#step-5-propose-updates-with-visual-formatting-requires-confirmation)
  - [Step 6: Apply Changes](#step-6-apply-changes)
  - [Step 7: Offer `AGENTS.md` Review (Optional)](#step-7-offer-agentsmd-review-optional)
- [Tips](#tips)

## Instructions

### Step 1: Ensure CLAUDE.md, GEMINI.md, and CODEX.md Exist

Check if `CLAUDE.md`, `GEMINI.md`, and `CODEX.md` exist in the project root. If missing or empty, create them using the templates below.

**CLAUDE.md:**

```markdown
# CLAUDE.md

This file is intentionally minimal.

**Authoritative project instructions live in `AGENTS.md`.**

You must:

1. Open and follow `AGENTS.md` before doing any work.
2. Treat `AGENTS.md` as the single source of truth for all operations.
3. Update `AGENTS.md` (not this file) when guidelines/architecture/standards change.

Read now: [AGENTS.md](./AGENTS.md)
```

**GEMINI.md:**

```markdown
# GEMINI.md

This file is intentionally minimal.

**Authoritative project instructions live in `AGENTS.md`.**

You must:

1. Open and follow `AGENTS.md` before doing any work.
2. Treat `AGENTS.md` as the single source of truth for all operations.
3. Update `AGENTS.md` (not this file) when guidelines/architecture/standards change.

Read now: [AGENTS.md](./AGENTS.md)
```

**CODEX.md:**

```markdown
# CODEX.md

This file is intentionally minimal.

**Authoritative project instructions live in `AGENTS.md`.**

You must:

1. Open and follow `AGENTS.md` before doing any work.
2. Treat `AGENTS.md` as the single source of truth for all operations.
3. Update `AGENTS.md` (not this file) when guidelines/architecture/standards change.

Read now: [AGENTS.md](./AGENTS.md)
```

### Step 2: Check for `AGENTS.md`

Check if `AGENTS.md` exists in the project root.

**If `AGENTS.md` exists**, read it to understand current content and proceed to Step 3.

**If `AGENTS.md` is missing**, use the `/init` command to create it. You will need to move the contents of `CLAUDE.md` to `AGENTS.md` and update `CLAUDE.md` as described in Step 1.

### Step 3: Comprehensive `AGENTS.md` Analysis (MANDATORY)

Before proposing any changes, perform a thorough review of the existing `AGENTS.md`:

1. **Build a Mental Map**
   - List all major sections and their purposes
   - Note the organizational pattern (by topic, workflow, etc.)

2. **Catalog Existing Content**
   - Key topics already covered
   - Specific conventions documented
   - Commands and workflows listed

3. **Flag Potential Conflicts**
   - Topics that might overlap with session learnings
   - Sections already comprehensive (avoid duplicates)

This analysis MUST inform what changes are proposed in Step 5.

### Step 4: Analyze Session Learnings

Review the conversation for:

- Coding patterns and preferences discovered
- Architecture decisions made
- Gotchas or pitfalls encountered
- Project conventions established
- Debugging insights
- Workflow preferences
- Anything that would be useful for another AI agent or human developer to know to be productive in this project

### Step 5: Propose Updates with Visual Formatting (REQUIRES CONFIRMATION)

**IMPORTANT: Do NOT make any changes yet.**

Present the exact proposed changes using this visual format:

````markdown
## Proposed Changes to`AGENTS.md`

> **Summary:** X additions, Y modifications, Z removals

---

### ➕ Additions (X)

> **Section: [Section Name]**
>
> ```diff
> + The new content being added
> ```

---

### Modifications (Y)

> **Section: [Section Name]**
>
> **Before:**
>
> ```diff
> - The old content
> ```
>
> **After:**
>
> ```diff
> + The new content
> ```

---

### ❌ Removals (Z)

> **Section: [Section Name]**
>
> ```diff
> - Content being removed
> ```
>
> **Reason:** [Why this is being removed]
````

**Format requirements:**

- Use blockquotes to create visual "boxes"
- Include a summary line with counts
- Use `diff` code blocks: `+` prefix for additions (green), `-` prefix for removals (red)
- Show Before/After for all modifications
- Require a reason for all removals

Then ask the user: **"Do you want me to apply these changes to `AGENTS.md`?"**

Wait for explicit confirmation before proceeding.

### Step 6: Apply Changes

**Only after user confirms**, apply the approved changes:

- Update `AGENTS.md` with the approved content
- Merge with existing content appropriately

### Step 7: Offer `AGENTS.md` Review (Optional)

After changes are applied, ask: **"Would you like me to review the entire `AGENTS.md` for cleanup opportunities?"**

If accepted, review for:

- **Duplicates** — same or near-identical instructions in multiple places
- **Stale content** — references to old patterns, removed files, or outdated practices
- **Consolidation** — related items scattered across sections that belong together
- **Clarity** — unclear instructions or verbose content that could be tightened

Present findings using the same visual format from Step 5. **Wait for explicit confirmation** before applying any cleanup changes.

## Tips

- If no meaningful learnings in this session, say so - don't force updates
- Prefer bullet points over paragraphs in `AGENTS.md`
- Include specific file paths when referencing project structure
- Avoid duplicating information already in `AGENTS.md`
- When reviewing, err on the side of keeping content if unsure
