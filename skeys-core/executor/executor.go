// Copyright (c) 2025 John Nelson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Package executor provides command execution utilities.
package executor

import (
	"bytes"
	"context"
	"fmt"
	"os/exec"
	"strings"
)

// Executor runs commands
type Executor interface {
	Run(ctx context.Context, name string, args ...string) ([]byte, error)
}

// LocalExecutor runs commands on the local machine
type LocalExecutor struct {
	allowedCommands map[string]bool
}

// NewLocalExecutor creates a new local executor
func NewLocalExecutor() *LocalExecutor {
	return &LocalExecutor{
		allowedCommands: map[string]bool{
			"ssh-keygen":  true,
			"ssh-add":     true,
			"ssh-agent":   true,
			"ssh":         true,
			"sshd":        true,
			"ssh-keyscan": true,
		},
	}
}

// Run executes a command
func (e *LocalExecutor) Run(ctx context.Context, name string, args ...string) ([]byte, error) {
	if !e.allowedCommands[name] {
		return nil, fmt.Errorf("command not allowed: %s", name)
	}

	// Note: We don't validate shell metacharacters here because exec.Command
	// runs commands directly without shell interpretation, making these chars safe.
	// The passphrase is passed as a direct argument to ssh-keygen, not through a shell.

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

// PrivilegeExecutor runs commands with elevated privileges
type PrivilegeExecutor struct {
	method          PrivilegeMethod
	allowedCommands map[string]bool
	allowedPaths    []string
}

// PrivilegeMethod specifies how to escalate privileges
type PrivilegeMethod int

const (
	PrivilegeMethodPkexec PrivilegeMethod = iota
	PrivilegeMethodSudo
)

// NewPrivilegeExecutor creates a new privilege executor
func NewPrivilegeExecutor(method PrivilegeMethod) *PrivilegeExecutor {
	return &PrivilegeExecutor{
		method: method,
		allowedCommands: map[string]bool{
			"sshd":      true,
			"systemctl": true,
			"cat":       true,
			"tee":       true,
		},
		allowedPaths: []string{
			"/etc/ssh/",
		},
	}
}

// Run executes a command with elevated privileges
func (e *PrivilegeExecutor) Run(ctx context.Context, name string, args ...string) ([]byte, error) {
	if !e.allowedCommands[name] {
		return nil, fmt.Errorf("command not allowed: %s", name)
	}

	var cmd *exec.Cmd

	switch e.method {
	case PrivilegeMethodPkexec:
		fullArgs := append([]string{name}, args...)
		cmd = exec.CommandContext(ctx, "pkexec", fullArgs...)
	case PrivilegeMethodSudo:
		fullArgs := append([]string{"-n", name}, args...)
		cmd = exec.CommandContext(ctx, "sudo", fullArgs...)
	}

	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()
	if err != nil {
		return nil, fmt.Errorf("%w: %s", err, stderr.String())
	}

	return stdout.Bytes(), nil
}

// ReadFile reads a file with elevated privileges
func (e *PrivilegeExecutor) ReadFile(ctx context.Context, path string) ([]byte, error) {
	if !e.isAllowedPath(path) {
		return nil, fmt.Errorf("path not allowed: %s", path)
	}

	return e.Run(ctx, "cat", path)
}

// WriteFile writes a file with elevated privileges
func (e *PrivilegeExecutor) WriteFile(ctx context.Context, path string, data []byte) error {
	if !e.isAllowedPath(path) {
		return fmt.Errorf("path not allowed: %s", path)
	}

	var cmd *exec.Cmd

	switch e.method {
	case PrivilegeMethodPkexec:
		cmd = exec.CommandContext(ctx, "pkexec", "tee", path)
	case PrivilegeMethodSudo:
		cmd = exec.CommandContext(ctx, "sudo", "-n", "tee", path)
	}

	cmd.Stdin = bytes.NewReader(data)

	var stderr bytes.Buffer
	cmd.Stderr = &stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to write file: %s", stderr.String())
	}

	return nil
}

// Execute runs a command with elevated privileges
func (e *PrivilegeExecutor) Execute(ctx context.Context, name string, args ...string) ([]byte, error) {
	return e.Run(ctx, name, args...)
}

// isAllowedPath checks if a path is in the allowed list
func (e *PrivilegeExecutor) isAllowedPath(path string) bool {
	for _, allowed := range e.allowedPaths {
		if strings.HasPrefix(path, allowed) {
			return true
		}
	}
	return false
}
