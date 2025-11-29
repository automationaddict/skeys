Perform a comprehensive production-readiness code review of: $ARGUMENTS

## Overview

This is a deep, end-to-end code review for battle-tested, production-ready code. Trace the feature from UI through backend, identify all issues, and create GitHub issues for each finding.

## Step 1: Map the Feature

1. **Identify all related files** by tracing the feature path:
   - Flutter UI: `lib/features/{feature}/presentation/`
   - Flutter BLoC: `lib/features/{feature}/bloc/`
   - Flutter Domain: `lib/features/{feature}/domain/`
   - Flutter Repository: `lib/features/{feature}/repository/`
   - Go Backend: `skeys-core/{package}/` and `skeys-daemon/`
   - gRPC definitions: `api/proto/`
   - Tests: `test/` and `*_test.go`

2. **Create a dependency graph** of how components interact

## Step 2: Review Categories

For each file, evaluate against these criteria:

### Code Quality
- SOLID principles violations
- DRY violations (duplicated code)
- Complex/nested conditionals that need refactoring
- Magic numbers/strings that should be constants
- Inconsistent naming conventions
- Dead code or unused imports
- Missing or incorrect type annotations
- Poor separation of concerns

### Security
- Input validation gaps
- Injection vulnerabilities (SQL, command, path traversal)
- Sensitive data exposure (logs, error messages)
- Authentication/authorization gaps
- Insecure cryptographic practices
- Race conditions
- Missing rate limiting
- Improper error handling that leaks info

### Performance
- N+1 query patterns
- Unnecessary rebuilds (Flutter)
- Missing memoization/caching opportunities
- Inefficient algorithms (O(n²) when O(n) possible)
- Memory leaks (unclosed streams, listeners)
- Blocking operations on main thread
- Large synchronous operations
- Missing pagination for lists

### Error Handling
- Uncaught exceptions
- Silent failures (empty catch blocks)
- Missing error states in UI
- Inconsistent error messaging
- Missing retry logic for network operations
- Missing timeout handling
- Improper cleanup on errors

### Testing
- Missing unit tests
- Missing integration tests
- Missing edge case coverage
- Flaky test patterns
- Missing mock coverage
- Untested error paths
- Missing BLoC state transition tests

### Accessibility
- Missing semantics labels
- Poor color contrast
- Missing keyboard navigation
- Touch target size issues
- Missing screen reader support
- Hard-coded text sizes

### Edge Cases
- Null/empty state handling
- Boundary conditions
- Concurrent modification handling
- Offline/network failure handling
- Large data set handling
- Unicode/i18n issues

### Documentation
- Missing public API documentation
- Outdated comments
- Missing README for complex modules
- Undocumented assumptions
- Missing changelog entries

## Step 3: Create GitHub Issues

For EACH finding, create a GitHub issue using:

```bash
gh issue create \
  --title "{type}: {brief description}" \
  --body "$(cat <<'EOF'
## Description
{Detailed description of the issue}

## Location
- File: `{file_path}`
- Line(s): {line_numbers}

## Current Behavior
{What the code currently does}

## Expected Behavior
{What production-ready code should do}

## Suggested Fix
{Concrete suggestion for fixing}

## References
- {Links to best practices, documentation, or examples}

---
*Found during code review of: {feature_path}*
EOF
)" \
  --label "{type_label}" \
  --label "{severity_label}" \
  --label "{area_label}"
```

### Labels to Use

**Type labels** (pick one):
- `bug` - Incorrect behavior
- `security` - Security vulnerability
- `performance` - Performance issue
- `tech-debt` - Code quality/maintainability
- `testing` - Test coverage gap
- `accessibility` - Accessibility issue
- `documentation` - Documentation gap

**Severity labels** (pick one):
- `critical` - Must fix before production
- `high` - Should fix soon
- `medium` - Fix when convenient
- `low` - Nice to have

**Area labels** (pick all that apply):
- `flutter` - Flutter/Dart code
- `go` - Go backend code
- `ui` - User interface
- `backend` - Backend/daemon
- `grpc` - gRPC/API layer
- `ci` - CI/CD related

## Step 4: Summary Report

After creating all issues, provide a summary:

```
## Review Summary: {feature_path}

### Files Reviewed
- {list of files}

### Issues Created
| # | Title | Severity | Type |
|---|-------|----------|------|
| {issue_number} | {title} | {severity} | {type} |

### Statistics
- Total issues: {count}
- By severity: {critical}/{high}/{medium}/{low}
- By type: {breakdown}

### Top Priorities
1. {most critical issue}
2. {second most critical}
3. {third most critical}
```

## Example Usage

- `/review Settings -> Display` - Review the settings display feature
- `/review Keys -> Add to Agent` - Review the add-to-agent flow
- `/review Agent -> Lock/Unlock` - Review agent locking feature
- `/review Config -> SSH Client` - Review SSH client config feature
