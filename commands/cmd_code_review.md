# Code Review Agent Rules

When asked to do a code review:

1. **Start with git diff**:

   - Do a `git diff main` to build context. If a specific branch is specified instead of `main` as the base, use that as the base instead.
   - Focus on semantic changes first, then formatting and NITs.
   - Understand the scope and intent of the changes.

2. **Navigate and analyze the codebase structure**:

   - Take time to navigate the entire tree structure before suggesting improvements
   - Understand how the changes fit within the broader project architecture
   - Identify areas where the changes impact other parts of the codebase
   - Look for patterns and conventions already established in the project

3. **Review with strategic focus**:

   - Does this align with project goals? Stability, readability, maintainability, etc..
   - Does it introduce unnecessary complexity or technical debt?
   - Does it follow established patterns and architecture?
   - **DevEx Scalability**: How will this code be understood and modified by future developers (especially juniors)?

4. **Build a comprehensive review plan**:

   - First, devise a plan for the review before implementing changes
   - Depending on the context of the changes, build a review plan.
   - For example:
     - if it's docs heavy, focus on readability.
     - If it's code heavy, evaluate if we're building frontend, backend, tooling, etc...
     - Prioritize UX and UI for frontend changes.
     - Prioritize correctness & simplicity for backend changes
     - Prioritize testing and edge cases for protocol changes
   - Include DevEx considerations: What will help developers 6 months from now?
   - Use your best judgement as an experienced protocol engineer otherwise

5. **Assess DevEx scalability opportunities**:

   - Identify complex logic that needs explanatory comments for future developers
   - Look for opportunities to add TODOs for future improvements or optimizations
   - Consider where inline documentation would help junior engineers understand the code
   - Flag areas where naming conventions could be clearer
   - Suggest architectural comments that explain "why" not just "what"
   - Note patterns that should be documented for team consistency
   - **Makefile Documentation**: Ensure all Makefile targets have proper `## Description` comments for developer workflows

6. **Make direct formatting improvements:**

   - Fix spacing, indentation, and blank line inconsistencies
   - Ensure consistent naming conventions and code style
   - Clean up any obvious formatting issues

7. **Enhance comments and documentation:**

   - Make comments concise and purpose-driven
   - Bias to bullet points for multi-step processes
   - Make docs & comment "idiot proof" with a bias to copy pasta
   - Use bullet points for multi-step processes
   - Remove redundant comments that just restate code
   - Add clarifying comments for complex logic
   - **DevEx Focus**: Add comments that help junior engineers understand design decisions
   - Document assumptions and constraints that aren't obvious from the code
   - If you're reformatting longs paragraphs/docs, do not lose content without asking for permission first

8. **Add or improve tests when:**

   - New logic lacks coverage
   - Edge cases are untested
   - Quick wins are available (≤15 min effort)
   - Critical paths need better validation

9. **Add TODOs strategically:**

   - DO NOT remove any existing TODOs added without permission
   - If there are non-blocking improvements or optimizations that can be made, add the appropriate TODO_XXX
   - If there are follow-up ideas worth considering later, add the appropriate TODO_XXX
   - **DevEx TODOs**: Add TODOs for areas that could benefit from refactoring for better maintainability
   - Include TODOs for missing documentation or examples that would help onboarding
   - Flag technical debt that impacts developer productivity

10. **Flag critical issues clearly:**

    - 🐛 Bugs, race conditions, or logic errors
    - 🚨 Security vulnerabilities or data exposure risks
    - 🏗️ Architectural concerns or brittle patterns
    - 📈 Performance issues or scalability concerns
    - 👥 DevEx concerns that will impact team productivity

11. **Summarize changes made:**

    - List direct edits vs. suggestions for follow-up
    - Highlight the most important improvements
    - Note any patterns or themes in the feedback
    - Call out specific DevEx improvements made or suggested

12. **Request permission for major changes:**

    - Refactoring or architectural shifts
    - Design pattern changes
    - Large-scale reorganization
    - Present the case and potential impact first

13. **Keep protobufs safe**

    - Do not allow renaming existing protobuf fields while maintaining the same number
    - Add reserved fields in protobufs for fields that were removed
    - If applicable, and not removing a field, mark it as deprecated for backwards compatibility
    - Lave a comment at the top with the "next free index"

14. **Makefile documentation consistency:**

    - Check all Makefile targets have proper documentation comments using the format: `target: ## Description`
    - Flag any `.PHONY` targets missing the `## Description` comment pattern
    - Ensure consistency with the project's established Makefile documentation standards
    - **DevEx Focus**: Well-documented Makefile targets are crucial for developer onboarding and daily workflows
    - Flag missing Makefile comments as a 👥 DevEx concern that impacts team productivity

15. **Golang specific rules** (i.e. in `.go` files only):

    - ONLY in `.go` files: For large numbers and constants, use `_` to separate digits for readability. E.g. `1_000_000` instead of `1000000`. ONLY