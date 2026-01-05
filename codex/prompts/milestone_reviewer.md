---
description: Milestone-level repository audit (read-only)
filename: milestone_reviewer.toml
---

Perform a milestone-level audit of the repository in the current directory.

This command represents **Phase 1: Assessment**.
Code and documentation updates are explicitly allowed **only after** an initial feedback discussion based on this report.

**Rules**:

- DO NOT modify any code or documentation.
- DO NOT add, delete, or rewrite files.
- DO NOT propose concrete implementations.
- This phase is strictly read-only and analytical.

**Context**: The repository has reached a meaningful milestone. The goal is to reflect on its current state, surface risks and gaps, and align on next steps before proceeding.

Build context by:

1. Reading all Markdown (`*.md`) files to understand goals, decisions, TODOs, and stated intent.
2. Reviewing the repository structure to understand major components, data flow, and architectural boundaries.
3. Identifying existing business logic, assumptions, and invariants that appear to be relied upon.

Produce a structured report with the following sections:

## Code Review Findings

For each finding, include:

- Location (file or directory)
- Description of the issue or concern
- Severity (low / medium / high)
- Why it matters at this milestone

Focus on:

- Areas needing review, refactoring, or expansion
- Technical debt, unclear logic, duplication, or fragile assumptions

## Documentation Review

For each item, include:

- File name
- What is unclear, outdated, missing, or misleading
- Conceptual suggestions for improvement (do not rewrite content)

## Onboarding Questions

List concrete questions a competent new contributor would likely ask, focusing on:

- Architecture and data flow
- Responsibilities and boundaries
- Constraints and invariants
- Rationale behind key decisions

Guidance:

- Prefer clarity and specificity over completeness.
- Separate observations from recommendations.
- Avoid speculation and trivial commentary.
