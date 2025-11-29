Close and merge the PR associated with issue $ARGUMENTS

## Workflow

1. **Find the PR** that fixes issue #$ARGUMENTS
   - Use `gh pr list --search "fixes #$ARGUMENTS in:body" --state open`
   - Or search for `closes #$ARGUMENTS`
   - Verify it's the correct PR

2. **Review PR status**
   - Check if CI/checks are passing
   - Verify the PR is ready to merge

3. **Merge the PR** using squash merge
   - Use `gh pr merge <pr_number> --squash`
   - This will automatically close the linked issue due to "Fixes #$ARGUMENTS" in PR body

4. **Pull changes locally**
   - Run `git pull` to sync the merged changes

5. **Confirm completion**
   - Verify issue is closed
   - Report to user: "Issue #$ARGUMENTS closed and merged via PR #XXX"

## Error Handling

- If no PR found, ask user to specify PR number
- If checks are failing, warn user before merging
- If PR is already merged, report status

## Example

```
User: /close 24
Claude:
1. Finds PR #385 that fixes issue #24
2. Checks that CI is passing
3. Merges PR #385 with squash
4. Pulls changes locally
5. Reports: "✅ Issue #24 closed and merged via PR #385"
```
