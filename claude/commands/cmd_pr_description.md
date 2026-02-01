# Quick PR Description

Generate a concise PR description by analyzing the diff against a base branch.

Output the result in a markdown file named `PR_DESCRIPTION.md`.

## Instructions

1. First, determine the base branch:
   - Ask the user if not specified
   - Common bases: `main`, `master`, or a feature branch
   - You can use `gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'`

2. Analyze the changes:

   ```bash
   git diff <base-branch> --stat
   git log <base-branch>..HEAD --oneline
   ```

3. Generate the description using the format below

## Output Format

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

## Style Rules

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

## Example Output

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
