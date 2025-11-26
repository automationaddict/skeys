package keys

import (
	"bytes"
	"context"
	"fmt"
	"os/exec"
)

// defaultExecutor is the default implementation using os/exec
type defaultExecutor struct{}

// Run executes a command and returns the output
func (e *defaultExecutor) Run(ctx context.Context, name string, args ...string) ([]byte, error) {
	// Validate command is in allowlist
	allowedCommands := map[string]bool{
		"ssh-keygen": true,
		"ssh-add":    true,
		"ssh-agent":  true,
	}

	if !allowedCommands[name] {
		return nil, fmt.Errorf("command not allowed: %s", name)
	}

	// Note: We don't check for shell metacharacters because exec.CommandContext
	// runs commands directly without shell interpretation, making these chars safe.
	// Passphrases can contain $, !, &, etc. without security issues.

	cmd := exec.CommandContext(ctx, name, args...)

	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()
	if err != nil {
		return nil, fmt.Errorf("%w: %s", err, stderr.String())
	}

	return stdout.Bytes(), nil
}
