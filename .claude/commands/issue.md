Work on GitHub issue #$ARGUMENTS

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
2. Create branch from base:
   - `git checkout {base} && git pull`
   - Branch name: `feature/issue-{number}-{short-kebab-description}`
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

## Example Usage

- `/issue 10` - Work on issue #10, branching from master
- `/issue 10 --base feature/settings` - Branch from feature/settings
