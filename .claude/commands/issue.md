Fix GitHub issue $ARGUMENTS and create a pull request

## Workflow

1. **Fetch issue details** using `gh issue view $ARGUMENTS`
2. **Analyze the issue** and understand what needs to be fixed
3. **Create a new branch** named `fix/issue-$ARGUMENTS`
4. **Implement the fix** following the project's conventions
5. **Run tests** to ensure the fix works and doesn't break anything
6. **Create a PR** with:
   - Title: Same as the issue or descriptive summary
   - Body: Include "Fixes #$ARGUMENTS" or "Closes #$ARGUMENTS" to auto-link
   - Clear description of what was changed and why

## Guidelines

- Follow existing code style and patterns in the repository
- Keep changes focused on fixing the specific issue
- Add tests if applicable
- Run `flutter test` for Flutter changes
- Run tests for Go changes if applicable
- Ensure no unrelated changes are included

## After Creating PR

- Tell the user the PR number
- Provide a summary of what was fixed
- User can review and use `/close <issue_number>` to merge when ready

## Example

```
User: /issue 24
Claude:
1. Fetches issue #24 details
2. Creates branch fix/issue-24
3. Implements the fix
4. Runs tests
5. Creates PR with "Fixes #24" in description
6. Reports: "Created PR #385 to fix issue #24"
```
