Clean up merged branches locally and remotely

**Usage:**
- `/cleanup` - Clean up ALL merged branches
- `/cleanup 24` - Clean up only the branch for issue #24

## Workflow

1. **Ensure you're on master/main**
   - Switch to master branch if not already there
   - Pull latest changes

2. **Determine branches to delete**
   - If $ARGUMENTS is provided (issue number):
     - Find branch matching pattern `*issue-$ARGUMENTS*` or `fix/issue-$ARGUMENTS` or `feature/issue-$ARGUMENTS`
     - Verify it's merged into master
   - If no $ARGUMENTS:
     - Find ALL branches that have been merged into master
   - Exclude master/main and current branch from deletion

3. **Delete local merged branches**
   - Use `git branch --merged master` to verify branches are merged
   - Delete each merged branch locally with `git branch -d <branch>`

4. **Delete remote branches (ALWAYS)**
   - For each local branch deleted, also delete the remote branch
   - Use `git push origin --delete <branch>` for each branch
   - Keep local and remote in sync ALWAYS

5. **Prune remote tracking branches**
   - Remove references to deleted remote branches
   - Use `git fetch --prune`

6. **Report summary**
   - List all branches that were deleted (local and remote)
   - Show remaining branches

## Safety Checks

- Never delete current branch
- Never delete master/main branches
- Only delete branches that are fully merged
- Always delete both local AND remote to keep in sync

## Example Output

**When cleaning specific issue:**
```
🧹 Cleaning up branch for issue #24...

Deleted:
  ✓ Local: fix/issue-24
  ✓ Remote: origin/fix/issue-24

✅ Cleanup complete!
```

**When cleaning all merged branches:**
```
🧹 Cleaning up all merged branches...

Deleted:
  ✓ fix/issue-24 (local + remote)
  ✓ feature/issue-21-remove-getit-dependency (local + remote)
  ✓ fix/auto-merge-permissions (local + remote)

Remaining local branches:
  * master
    fix/issue-30 (not merged yet)

✅ Cleanup complete! Deleted 3 branches (local + remote)
```

## Example Usage

```
User: /cleanup
Claude: Cleans up ALL merged branches (local + remote)

User: /cleanup 24
Claude: Cleans up only the branch for issue #24 (local + remote)
```
