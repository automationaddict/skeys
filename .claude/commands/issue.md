Work on GitHub issue #$ARGUMENTS

## Pre-Work Cleanup

Before starting work, clean up any stale branches from previously merged PRs:

1. **Checkout and update base branch**:
   ```bash
   git checkout {base} && git pull
   ```

2. **Find and clean up merged feature branches**:
   - List all local feature branches: `git branch | grep "^  feature/issue-"`
   - For each branch, check if its PR was merged: `gh pr list --state merged --head {branch}`
   - If merged, delete the local branch: `git branch -D {branch}`

3. **Prune stale remote tracking branches**:
   ```bash
   git fetch --prune
   ```

This ensures you start with a clean workspace and don't accumulate stale branches.

## Pre-Work Checks

1. **Fetch issue details**: `gh issue view {number} --json title,body,labels,state`
2. **Check if already closed**: If closed, report and stop
3. **Duplicate detection**:
   - Search closed issues: `gh issue list --state closed --search "{keywords from title}"`
   - Search open issues: `gh issue list --state open --search "{keywords}"`
   - If potential duplicates found, list them and ask user before proceeding
   - If confirmed duplicate, close with "Duplicate of #X" and stop
4. **Find related issues**:
   - Search for issues with similar labels or keywords
   - Note related issues to cross-link in PR

## Branch & Development

1. Parse arguments:
   - First argument: Issue number (required)
   - `--base <branch>`: Base branch (default: master)
2. Create branch from base (already on updated base from cleanup):
   - Branch name: `feature/issue-{number}-{short-kebab-description}`
   - `git checkout -b {branch_name}`
3. Work on the issue following normal development practices
4. Commit with conventional commit format referencing issue

## PR Creation

When complete, create PR with:
- Title: `{type}: {description} (#{issue_number})`
- Body template:
  ```
  ## Summary
  {Brief description of changes}

  Closes #{issue_number}

  ## Related Issues
  - Related to #{related_issue} (if any)

  ## Changes
  - {bullet points of changes}

  ## Test Plan
  - {how it was tested}
  ```
- Labels: `auto-merge` + labels from original issue
- Auto-request merge after CI passes

## Post-Merge

After the PR is merged, the feature branch cleanup will happen automatically the next time you run `/issue` (during the Pre-Work Cleanup step).

## Example Usage

- `/issue 10` - Work on issue #10, branching from master
- `/issue 10 --base feature/settings` - Branch from feature/settings
