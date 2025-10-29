# GitHub Description

You are responsible for generating a GitHub PR description for a given diff.

Start by doing a `git diff main --name-only` to see what files have changed.

Optionally, you can use the following tool to generate a diff of the key changes only

```bash
git --no-pager diff main -- ':!*.pb.go' ':!*.pulsar' | diff2html -s side --format json -i stdin -o stdout | pbcopy
```

Make sure to ignore other files that are not relevant to the PR (e.g. like .pb.go files, etc)

Then, depending ont he size of the change, provide a description in one of the following formats

## General Guidelines for all Formats

- Keep the bullet points concise
- Escape key terms with backticks
- Primary changes are what the PR is all about
- Secondary changes include misc changes (e.g. documentation updates, etc)
- Limit the number of bullets to 3-5

## GitHub Admonitions

GitHub provides a few admonition styles that can be used to highlight important information.

Leverage these sparingly but strategically to highlight important information.

```markdown
> [!NOTE]
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]
> Crucial information necessary for users to succeed.

> [!WARNING]
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.
```

Reference: [GitHub Admonitions](https://github.com/orgs/community/discussions/16925)

## Format 1: Small Changes

Provide a diff in 3-5 bullet points where each one is less than 80 characters long.

## Format 2: Large Changes

```markdown
## Summary

< One line summary >

### Primary Changes:

- < core changes # 1 >
- < core changes # 2 >
- ...

### Secondary changes:

- < secondary changes # 1 >
- < secondary changes # 2 >
- ...
```
