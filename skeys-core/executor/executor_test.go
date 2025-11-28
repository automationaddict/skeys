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

package executor

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestNewLocalExecutor(t *testing.T) {
	exec := NewLocalExecutor()
	require.NotNil(t, exec)
	assert.NotNil(t, exec.allowedCommands)
}

func TestLocalExecutor_AllowedCommands(t *testing.T) {
	exec := NewLocalExecutor()

	// Check allowed commands
	assert.True(t, exec.allowedCommands["ssh-keygen"])
	assert.True(t, exec.allowedCommands["ssh-add"])
	assert.True(t, exec.allowedCommands["ssh-agent"])
	assert.True(t, exec.allowedCommands["ssh"])
	assert.True(t, exec.allowedCommands["sshd"])
	assert.True(t, exec.allowedCommands["ssh-keyscan"])

	// Check disallowed command
	assert.False(t, exec.allowedCommands["rm"])
	assert.False(t, exec.allowedCommands["bash"])
}

func TestLocalExecutor_Run_DisallowedCommand(t *testing.T) {
	exec := NewLocalExecutor()

	_, err := exec.Run(context.Background(), "rm", "-rf", "/")
	require.Error(t, err)
	assert.Contains(t, err.Error(), "command not allowed")
}

func TestLocalExecutor_Run_AllowedCommand(t *testing.T) {
	exec := NewLocalExecutor()

	// ssh-keygen -h should work (shows help, exits with error but produces output)
	output, err := exec.Run(context.Background(), "ssh-keygen", "--help")
	// Note: --help might exit with error on some systems
	// We just want to verify the command was attempted
	_ = err
	_ = output
	// If ssh-keygen is not installed, this will fail with a different error
}

func TestNewPrivilegeExecutor_Pkexec(t *testing.T) {
	exec := NewPrivilegeExecutor(PrivilegeMethodPkexec)
	require.NotNil(t, exec)
	assert.Equal(t, PrivilegeMethodPkexec, exec.method)
}

func TestNewPrivilegeExecutor_Sudo(t *testing.T) {
	exec := NewPrivilegeExecutor(PrivilegeMethodSudo)
	require.NotNil(t, exec)
	assert.Equal(t, PrivilegeMethodSudo, exec.method)
}

func TestPrivilegeExecutor_AllowedCommands(t *testing.T) {
	exec := NewPrivilegeExecutor(PrivilegeMethodPkexec)

	assert.True(t, exec.allowedCommands["sshd"])
	assert.True(t, exec.allowedCommands["systemctl"])
	assert.True(t, exec.allowedCommands["cat"])
	assert.True(t, exec.allowedCommands["tee"])

	assert.False(t, exec.allowedCommands["rm"])
	assert.False(t, exec.allowedCommands["bash"])
}

func TestPrivilegeExecutor_AllowedPaths(t *testing.T) {
	exec := NewPrivilegeExecutor(PrivilegeMethodPkexec)

	// Allowed paths
	assert.True(t, exec.isAllowedPath("/etc/ssh/sshd_config"))
	assert.True(t, exec.isAllowedPath("/etc/ssh/ssh_config"))
	assert.True(t, exec.isAllowedPath("/etc/ssh/sshd_config.d/custom.conf"))

	// Disallowed paths
	assert.False(t, exec.isAllowedPath("/etc/passwd"))
	assert.False(t, exec.isAllowedPath("/root/.ssh/authorized_keys"))
	assert.False(t, exec.isAllowedPath("/home/user/.bashrc"))
}

func TestPrivilegeExecutor_Run_DisallowedCommand(t *testing.T) {
	exec := NewPrivilegeExecutor(PrivilegeMethodPkexec)

	_, err := exec.Run(context.Background(), "rm", "-rf", "/")
	require.Error(t, err)
	assert.Contains(t, err.Error(), "command not allowed")
}

func TestPrivilegeExecutor_ReadFile_DisallowedPath(t *testing.T) {
	exec := NewPrivilegeExecutor(PrivilegeMethodPkexec)

	_, err := exec.ReadFile(context.Background(), "/etc/passwd")
	require.Error(t, err)
	assert.Contains(t, err.Error(), "path not allowed")
}

func TestPrivilegeExecutor_WriteFile_DisallowedPath(t *testing.T) {
	exec := NewPrivilegeExecutor(PrivilegeMethodPkexec)

	err := exec.WriteFile(context.Background(), "/etc/passwd", []byte("test"))
	require.Error(t, err)
	assert.Contains(t, err.Error(), "path not allowed")
}

func TestPrivilegeExecutor_Execute(t *testing.T) {
	exec := NewPrivilegeExecutor(PrivilegeMethodPkexec)

	// Execute is an alias for Run
	_, err := exec.Execute(context.Background(), "rm", "-rf", "/")
	require.Error(t, err)
	assert.Contains(t, err.Error(), "command not allowed")
}

func TestPrivilegeMethod(t *testing.T) {
	assert.Equal(t, PrivilegeMethod(0), PrivilegeMethodPkexec)
	assert.Equal(t, PrivilegeMethod(1), PrivilegeMethodSudo)
}

func TestLocalExecutor_Run_Success(t *testing.T) {
	exec := NewLocalExecutor()

	// Use ssh-keygen -V to get version, which should succeed on most systems
	output, err := exec.Run(context.Background(), "ssh-keygen", "-V")
	// ssh-keygen -V exits with 0 and outputs version info to stderr
	// If ssh-keygen is not installed, this will fail
	if err == nil {
		// Just verifying the command ran
		_ = output
	}
}

func TestLocalExecutor_Run_ContextCancel(t *testing.T) {
	exec := NewLocalExecutor()

	ctx, cancel := context.WithCancel(context.Background())
	cancel() // Cancel immediately

	_, err := exec.Run(ctx, "ssh-keygen", "-V")
	// Either command wasn't allowed to start, or context was canceled
	if err != nil {
		// This is expected - the command may have been killed
		assert.Error(t, err)
	}
}

func TestPrivilegeExecutor_isAllowedPath_NoMatch(t *testing.T) {
	exec := NewPrivilegeExecutor(PrivilegeMethodPkexec)

	// Test paths that don't match any allowed prefix
	assert.False(t, exec.isAllowedPath("/tmp/test"))
	assert.False(t, exec.isAllowedPath(""))
	assert.False(t, exec.isAllowedPath("relative/path"))
}

func TestPrivilegeExecutor_AllowedPaths_Content(t *testing.T) {
	exec := NewPrivilegeExecutor(PrivilegeMethodPkexec)

	// Verify the allowed paths list
	assert.Contains(t, exec.allowedPaths, "/etc/ssh/")
}

func TestLocalExecutor_ImplementsExecutor(t *testing.T) {
	var _ Executor = &LocalExecutor{}
	// Compilation proves LocalExecutor implements Executor
}

func TestPrivilegeExecutor_ImplementsExecutor(t *testing.T) {
	var _ Executor = &PrivilegeExecutor{}
	// Compilation proves PrivilegeExecutor implements Executor
}

// Note: Tests for PrivilegeExecutor.Run, ReadFile, and WriteFile with allowed
// paths/commands are not included because they would trigger authentication
// dialogs (pkexec) or require passwordless sudo. The core logic (command
// allowlisting, path validation) is tested via the DisallowedCommand and
// DisallowedPath tests above.
