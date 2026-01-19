# TODO

## Sync Skills Across Agents

Research and implement a strategy for syncing skills across Claude Code, Gemini CLI, and OpenAI Codex.

### Background

All three agent CLIs use a similar skill format based on the [Agent Skills open standard](https://github.com/anthropics/agent-skills):

| Feature | Claude Code | Gemini CLI | OpenAI Codex |
|---------|-------------|------------|--------------|
| Entry file | `SKILL.md` | `SKILL.md` | `SKILL.md` |
| Metadata | YAML frontmatter | YAML frontmatter | YAML frontmatter |
| Required fields | `name`, `description` | `name`, `description` | `name`, `description` |
| Optional dirs | `scripts/`, `references/`, `assets/` | `scripts/`, `references/`, `assets/` | `scripts/`, `references/`, `assets/` |
| User location | `~/.claude/skills/` | `~/.gemini/skills/` | `~/.codex/skills/` |
| Project location | `.claude/skills/` | `.gemini/skills/` | `.codex/skills/` |

### Key Differences

- **Claude Code**: Has additional metadata like `allowed-tools`, `model`, `context: fork`, `user-invocable`, `hooks`
- **Gemini CLI**: Has discovery tiers (workspace → user → extension)
- **OpenAI Codex**: Has admin location (`/etc/codex/skills`) and system bundled defaults

### Tasks

- [ ] Audit existing skills in `~/.claude/skills/`
- [ ] Identify portable skills that work across all three platforms
- [ ] Create a sync script that copies/symlinks skills to all three locations
- [ ] Handle platform-specific metadata gracefully (extra fields are ignored)
- [ ] Test skill activation on each platform
- [ ] Document which skills are portable vs platform-specific

### References

- [Claude Code Skills](https://code.claude.com/docs/en/skills)
- [Gemini CLI Skills](https://geminicli.com/docs/cli/skills/)
- [OpenAI Codex Skills](https://developers.openai.com/codex/skills/)
