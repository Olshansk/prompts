# Olshansky's CLAUDE.md <!-- omit in toc -->

- [Writing Code](#writing-code)
- [Python](#python)
- [Documentation](#documentation)
- [Agent Rules Integration](#agent-rules-integration)
- [Git Workflow Integration](#git-workflow-integration)
- [MCP Server Management](#mcp-server-management)
- [Context Loading Strategy](#context-loading-strategy)
- [Custom Skills](#custom-skills)
- [General Guidelines in code](#general-guidelines-in-code)
- [TODO Comment Standards](#todo-comment-standards)
- [Response Status Tags](#response-status-tags)

## Writing Code

- Bias to writing less code if possible
- Leverage standard or open source libraries/tools rather than reinvesting the wheel
- Focus on solving the problem, not trying to be a "clever engineer"
- Be motivated by simplicity and speed to problem resolution, not "nerd sniping" anyone

## Python

**Always use `uv` for Python projects unless explicitly told otherwise.**

- Use `uv sync` instead of `pip install`
- Use `uv run python` instead of `python` or `.venv/bin/python`
- Use `uv run <tool>` for running tools (pytest, ruff, mypy, etc.)
- Create `pyproject.toml` for dependencies, not `requirements.txt`
- Use `uv add <package>` to add dependencies

## Documentation

When writing READMes, start with the following direction:

- Table of Contents: Always add a Table of Contents for documentation
- Ignoring Headers in ToC: ignore the top level or deeply nested headers using <!-- omit in toc -->
- Language: Bias to bullet points and subheadders over paragraphs, but don't over do it.
- Content: start with the payoff and details below. Don't add content like "this is scalable" that doesn't create real value add
- Triple quotes: always add the appropriate syntax highlighting. For example: ```bash...`
- References: Use industry best practices from great products as a reference for how they write their documentation
- Copy-pasta: Provide easy-copy pasta instructions that enable developers to onboard brainlessley

## Agent Rules Integration

@~/workspace/agent-rules

### Common Development Commands <!-- omit in toc -->

- Use `/check` for comprehensive quality checks (linting, type checking, security)
- Use `/commit` for structured commits with conventional format and emoji prefixes
- Use `/implement-task` for methodical task implementation with planning phases
- Use `/clean` to fix all formatting and linting issues across codebase
- Use `/context-prime` to load comprehensive project understanding

### Documentation Standards <!-- omit in toc -->

- Reference specific functions with `file_path:line_number` format
- Generate LLM-optimized documentation with file references
- Follow Keep a Changelog format for changelog updates
- Include table of contents for longer documentation

### Multi-Language Quality Patterns <!-- omit in toc -->

**Python (uv):**

```bash
# Dependency management (prefer uv over pip)
uv sync --all-extras        # Install deps (not pip install)
uv run python script.py     # Run scripts (not .venv/bin/python)
uv run pytest               # Run tools through uv

# Quality checks
uv run ruff check --fix .
uv run ruff format .
uv run mypy .
```

**Python (legacy/pip):**

```bash
black .
isort .
flake8 . --extend-ignore=E203
mypy .
```

**JavaScript/TypeScript:**

```bash
npx prettier --write .
npx eslint . --fix
npx tsc --noEmit
```

**Swift:**

```bash
swift-format --in-place .
swiftlint --fix
```

## Git Workflow Integration

- Conventional commit format: `type(scope): description`
- Emoji prefixes: ✨ feat, 🐛 fix, 📝 docs, ♻️ refactor
- Run quality checks before commits
- No commits during active quality check processes

## MCP Server Management

- Use `~/workspace/agent-rules/global-rules/mcp-sync.sh` to synchronize MCP configurations
- Review configuration differences across Claude Desktop, Cursor, VS Code
- Switch between local development and global npm packages

## Context Loading Strategy

1. Read README.md and CLAUDE.md
2. List project structure (`git ls-files | head -50`)
3. Review configuration files (package.json, Cargo.toml, etc.)
4. Understand development workflow

## Custom Skills

**IMPORTANT:** Check `~/.claude/skills/` for reusable skill definitions before starting relevant tasks.

When a user mentions a "skill" (e.g., "makefile skill", "use your X skill"), always check this directory first:

```bash
ls ~/.claude/skills/
```

Available skills:

- `makefile/` - Makefile conventions, templates, and patterns. Read `SKILL.md` for guidelines, check `templates/` for starter files.

Each skill directory contains:
- `SKILL.md` - Core principles and when to use
- `reference.md` - Detailed patterns and examples
- `templates/` - Copy-paste starter files
- `modules/` - Reusable components

## General Guidelines in code

- Be concise yet clear—don't sacrifice context.
- Trim comment noise while preserving meaning.
- Follow best practices for the language in use.
- Break long paragraphs (>3 sentences) or run-on sentences into bullet points.
- Start new sentences on new lines when they stand alone.
- Never remove any content from the original input.

## TODO Comment Standards

Use specific TODO prefixes to categorize action items:

- `TODO:` - General improvements or future work (default)
- `TODO_IMPROVE:` - Code quality improvements, refactoring opportunities
- `TODO_IN_THIS_PR:` - Tasks to complete within the current pull request
- `FIXME:` - Known bugs or issues that need fixing
- `HACK:` - Temporary workarounds that should be replaced
- `NOTE:` - Important explanations or warnings for developers

Example:

```python
# TODO_IMPROVE: Implement connection pooling for better performance
# TODO_IN_THIS_PR: Add input validation
# FIXME: Race condition when multiple requests arrive simultaneously
# HACK: Hardcoded timeout until we implement configurable settings
```

## Response Status Tags

End every response with exactly one of these tags (on its own line):

- `[✅ CLAUDE - DONE - SUCCESS]` - Task completed successfully (this should be green)
- `[❌ CLAUDE - DONE - FAILED]` - Task attempted but failed or encountered errors (this should be red)
- `[⏳ CLAUDE - INPUT NEEDED]` - Blocked waiting for user input, clarification, or approval (this should be yellow)
