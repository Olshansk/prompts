---
name: cmd-pr-description
description: Generate concise PR descriptions by analyzing the diff against a base branch
disable-model-invocation: true
---

# Quick PR Description

Generate a concise PR description by analyzing the diff against a base branch.

Output the result in a markdown file named `PR_DESCRIPTION.md`.

## Instructions

1. First, determine the base branch using the repository's default branch:

   Try these methods in order until one succeeds:

   **Method 1 - GitHub CLI:**
   ```bash
   BASE_BRANCH=$(gh repo view --json defaultBranchRef -q '.defaultBranchRef.name' 2>/dev/null)
   ```

   **Method 2 - Git remote:**
   ```bash
   BASE_BRANCH=$(git remote show origin 2>/dev/null | grep "HEAD branch" | cut -d: -f2 | xargs)
   ```

   **Method 3 - Git symbolic-ref:**
   ```bash
   BASE_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
   ```

   **IMPORTANT:** Do NOT assume `main` as a fallback. If all methods fail, ask the user which branch to use as the base.

2. Analyze the changes against the default branch:

   ```bash
   git diff $BASE_BRANCH --stat -- ":(exclude)*.lock" ":(exclude)package-lock.json" ":(exclude)pnpm-lock.yaml" ":(exclude)package.json"
   git log $BASE_BRANCH..HEAD --oneline
   ```

3. Generate the description using the format below

## Output Format

### Summary

Write 3-5 bullet points. Each bullet follows this format:

```markdown
- **Product-level value** - One sentence explaining what changed and why it matters
```

Focus on what the PR delivers for users, operators, or developers -- not implementation details.

```markdown
- **Faster giveaway queries** - Entries and winners now track account IDs directly, eliminating slow multi-table joins
- **Hourly giveaway alignment** - Start and end times must land on the hour to match the cron schedule that manages giveaway lifecycles
- **Auto-close expired giveaways** - New admin endpoint lets a cron job transition active giveaways to ended when their time is up
- **Wallet-first accounts can log in** - Accounts created via wallet linking now get a primary identity so JWT auth works
```

## Style Rules

- **3-5 bullets total** -- one bullet per meaningful change, not per file
- **Bold the value** -- the bold phrase should answer "what does the user/operator get?"
- **Plain language after the dash** -- one sentence, no jargon, no function/file/variable names
- **No implementation details** -- skip function names, file names, column names, migration IDs, etc. Reviewers will read the diff for that
- **No fluff** -- skip "minor cleanup", "refactor", "update docs" unless they deliver real value
- **Start from the most impactful change** and work down

## Example Output

```markdown
- **Session-based login** - Users can now log in with email/password and stay authenticated across browser sessions
- **Faster auth checks** - Session lookups use an indexed token column instead of scanning the full users table
- **Remember-me support** - Users can opt into 30-day sessions instead of the default 24-hour expiry
```

<details>
<summary>Detailed Change Groups (optional, for larger PRs)</summary>

### Grouped Format

Group related changes under `# Change Title` headers with bullet points:

```markdown
# Change Title

- Brief description of what was done
- Use `backticks` around file names, function names, variables, endpoints
- Keep bullets concise (1 line each)

# Another Change

- Another set of related changes
- More details with `code_references`
```

### Grouped Style Rules

- **Headers**: Use `# Change Title` for each logical group of changes
- **Backticks**: Wrap these in backticks:
  - File names: `identity_sync.py`
  - Functions: `get_cdp_end_user()`
  - Variables: `cdp_token`
  - Endpoints: `/auth/login/complete`
  - Config keys, env vars, etc.
- **Bullets**:
  - Start with action verb (Add, Remove, Update, Fix, Refactor)
  - Keep to 1 line, ~80 chars max
  - 3-5 bullets per section
- **Grouping**: Group by feature/concern, not by file
- **No fluff**: Skip "minor changes", "cleanup", etc. unless significant

### Grouped Example

```markdown
# User Authentication

- Add `login_service.py` with JWT-based session management
- Integrate `/auth/login` and `/auth/logout` endpoints
- Support `remember_me` flag for extended session duration

# Database Schema

- Add `sessions` table with `user_id`, `token`, `expires_at` columns
- Add index on `expires_at` for cleanup job performance

# Tests

- Add 15 unit tests for `login_service.py`
- Add integration tests for auth endpoints
```

</details>
