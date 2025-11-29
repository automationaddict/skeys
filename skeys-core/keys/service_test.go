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

package keys

import (
	"context"
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
)

// MockAgentChecker implements AgentChecker for testing
type MockAgentChecker struct {
	mock.Mock
}

func (m *MockAgentChecker) ListLoadedFingerprints() ([]string, error) {
	args := m.Called()
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).([]string), args.Error(1)
}

func (m *MockAgentChecker) RemoveKeyByFingerprint(fingerprint string) error {
	args := m.Called(fingerprint)
	return args.Error(0)
}

func (m *MockAgentChecker) SubscribeChanges(ctx context.Context) <-chan struct{} {
	ch := make(chan struct{})
	close(ch) // Return closed channel for tests
	return ch
}

// createTestKey creates a test key and returns its path
func createTestKey(t *testing.T, sshDir, name string, withPassphrase bool) string {
	t.Helper()
	gen := NewKeyGenerator()
	keyPath := filepath.Join(sshDir, name)

	opts := GenerateOptions{
		Name:    name,
		Type:    KeyTypeED25519,
		Comment: name + "@test.com",
		path:    keyPath,
	}
	if withPassphrase {
		opts.Passphrase = "testpassphrase"
	}

	err := gen.GenerateKeyPair(opts)
	require.NoError(t, err)
	return keyPath
}

func TestNewService(t *testing.T) {
	tmpDir := t.TempDir()

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)
	assert.NotNil(t, svc)
}

func TestNewService_CreatesSSHDir(t *testing.T) {
	tmpDir := t.TempDir()
	sshDir := filepath.Join(tmpDir, ".ssh")

	// Directory doesn't exist yet
	_, err := os.Stat(sshDir)
	require.True(t, os.IsNotExist(err))

	svc, err := NewService(WithSSHDir(sshDir))
	require.NoError(t, err)
	assert.NotNil(t, svc)

	// Directory should now exist with correct permissions
	info, err := os.Stat(sshDir)
	require.NoError(t, err)
	assert.True(t, info.IsDir())
	assert.Equal(t, os.FileMode(0700), info.Mode().Perm())
}

func TestService_List_Empty(t *testing.T) {
	tmpDir := t.TempDir()

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	keys, err := svc.List(context.Background())
	require.NoError(t, err)
	assert.Empty(t, keys)
}

func TestService_List_WithKeys(t *testing.T) {
	tmpDir := t.TempDir()

	// Create some test keys
	createTestKey(t, tmpDir, "test_key1", false)
	createTestKey(t, tmpDir, "test_key2", false)

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	keys, err := svc.List(context.Background())
	require.NoError(t, err)
	assert.Len(t, keys, 2)

	// Check key names
	names := make([]string, len(keys))
	for i, k := range keys {
		names[i] = k.Name
	}
	assert.Contains(t, names, "test_key1")
	assert.Contains(t, names, "test_key2")
}

func TestService_List_SkipsNonKeyFiles(t *testing.T) {
	tmpDir := t.TempDir()

	// Create a key
	createTestKey(t, tmpDir, "test_key", false)

	// Create files that should be skipped
	os.WriteFile(filepath.Join(tmpDir, "config"), []byte("Host *"), 0644)
	os.WriteFile(filepath.Join(tmpDir, "known_hosts"), []byte(""), 0644)
	os.WriteFile(filepath.Join(tmpDir, "authorized_keys"), []byte(""), 0644)
	os.WriteFile(filepath.Join(tmpDir, ".hidden"), []byte(""), 0644)

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	keys, err := svc.List(context.Background())
	require.NoError(t, err)
	assert.Len(t, keys, 1)
	assert.Equal(t, "test_key", keys[0].Name)
}

func TestService_Get(t *testing.T) {
	tmpDir := t.TempDir()
	createTestKey(t, tmpDir, "my_key", false)

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	key, err := svc.Get(context.Background(), "my_key")
	require.NoError(t, err)
	assert.Equal(t, "my_key", key.Name)
	assert.Equal(t, KeyTypeED25519, key.Type)
	assert.Equal(t, "my_key@test.com", key.Comment)
	assert.NotEmpty(t, key.FingerprintSHA256)
	assert.False(t, key.HasPassphrase)
}

func TestService_Get_WithPassphrase(t *testing.T) {
	tmpDir := t.TempDir()
	createTestKey(t, tmpDir, "encrypted_key", true)

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	key, err := svc.Get(context.Background(), "encrypted_key")
	require.NoError(t, err)
	assert.True(t, key.HasPassphrase)
}

func TestService_Get_NotFound(t *testing.T) {
	tmpDir := t.TempDir()

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	_, err = svc.Get(context.Background(), "nonexistent")
	require.Error(t, err)
}

func TestService_Generate(t *testing.T) {
	tmpDir := t.TempDir()

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	key, err := svc.Generate(context.Background(), GenerateOptions{
		Name:    "new_key",
		Type:    KeyTypeED25519,
		Comment: "new@test.com",
	})
	require.NoError(t, err)
	assert.Equal(t, "new_key", key.Name)
	assert.Equal(t, KeyTypeED25519, key.Type)
	assert.Equal(t, "new@test.com", key.Comment)

	// Verify files exist
	_, err = os.Stat(filepath.Join(tmpDir, "new_key"))
	require.NoError(t, err)
	_, err = os.Stat(filepath.Join(tmpDir, "new_key.pub"))
	require.NoError(t, err)
}

func TestService_Generate_DefaultType(t *testing.T) {
	tmpDir := t.TempDir()

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	key, err := svc.Generate(context.Background(), GenerateOptions{
		Name: "default_type",
	})
	require.NoError(t, err)
	assert.Equal(t, KeyTypeED25519, key.Type)
}

func TestService_Generate_AlreadyExists(t *testing.T) {
	tmpDir := t.TempDir()
	createTestKey(t, tmpDir, "existing_key", false)

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	_, err = svc.Generate(context.Background(), GenerateOptions{
		Name: "existing_key",
	})
	require.Error(t, err)
	assert.Contains(t, err.Error(), "already exists")
}

func TestService_Generate_InvalidName(t *testing.T) {
	tmpDir := t.TempDir()

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	tests := []struct {
		name        string
		expectedErr string
	}{
		{"", "cannot be empty"},
		{"path/to/key", "cannot contain path separators"},
		{".hidden", "cannot start with a dot"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, err = svc.Generate(context.Background(), GenerateOptions{
				Name: tt.name,
			})
			require.Error(t, err)
			assert.Contains(t, err.Error(), tt.expectedErr)
		})
	}
}

func TestService_Delete(t *testing.T) {
	tmpDir := t.TempDir()
	createTestKey(t, tmpDir, "to_delete", false)

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	err = svc.Delete(context.Background(), "to_delete")
	require.NoError(t, err)

	// Verify files are gone
	_, err = os.Stat(filepath.Join(tmpDir, "to_delete"))
	assert.True(t, os.IsNotExist(err))
	_, err = os.Stat(filepath.Join(tmpDir, "to_delete.pub"))
	assert.True(t, os.IsNotExist(err))
}

func TestService_Delete_WithAgentChecker(t *testing.T) {
	tmpDir := t.TempDir()
	createTestKey(t, tmpDir, "agent_key", false)

	mockAgent := new(MockAgentChecker)
	// Expect RemoveKeyByFingerprint to be called
	mockAgent.On("RemoveKeyByFingerprint", mock.AnythingOfType("string")).Return(nil)

	svc, err := NewService(
		WithSSHDir(tmpDir),
		WithAgentChecker(mockAgent),
	)
	require.NoError(t, err)

	err = svc.Delete(context.Background(), "agent_key")
	require.NoError(t, err)

	mockAgent.AssertExpectations(t)
}

func TestService_Delete_ByPath(t *testing.T) {
	tmpDir := t.TempDir()
	keyPath := createTestKey(t, tmpDir, "path_delete", false)

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	err = svc.Delete(context.Background(), keyPath)
	require.NoError(t, err)

	_, err = os.Stat(keyPath)
	assert.True(t, os.IsNotExist(err))
}

func TestService_Fingerprint(t *testing.T) {
	tmpDir := t.TempDir()
	createTestKey(t, tmpDir, "fp_key", false)

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	fp, err := svc.Fingerprint(context.Background(), "fp_key", "sha256")
	require.NoError(t, err)
	assert.True(t, len(fp) > 0)
	assert.Contains(t, fp, "SHA256:")
}

func TestService_ChangePassphrase(t *testing.T) {
	tmpDir := t.TempDir()
	createTestKey(t, tmpDir, "change_pass", false)

	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	// Add passphrase
	err = svc.ChangePassphrase(context.Background(), "change_pass", "", "newpass")
	require.NoError(t, err)

	// Verify passphrase was added
	key, err := svc.Get(context.Background(), "change_pass")
	require.NoError(t, err)
	assert.True(t, key.HasPassphrase)
}

func TestService_InAgent_WithMock(t *testing.T) {
	tmpDir := t.TempDir()
	createTestKey(t, tmpDir, "agent_test", false)

	// Get the fingerprint first
	gen := NewKeyGenerator()
	fp, err := gen.CalculateFingerprint(filepath.Join(tmpDir, "agent_test.pub"), "sha256")
	require.NoError(t, err)

	mockAgent := new(MockAgentChecker)
	mockAgent.On("ListLoadedFingerprints").Return([]string{fp}, nil)

	svc, err := NewService(
		WithSSHDir(tmpDir),
		WithAgentChecker(mockAgent),
	)
	require.NoError(t, err)

	key, err := svc.Get(context.Background(), "agent_test")
	require.NoError(t, err)
	assert.True(t, key.InAgent)

	mockAgent.AssertExpectations(t)
}

func TestService_NotInAgent_WithMock(t *testing.T) {
	tmpDir := t.TempDir()
	createTestKey(t, tmpDir, "not_in_agent", false)

	mockAgent := new(MockAgentChecker)
	mockAgent.On("ListLoadedFingerprints").Return([]string{"SHA256:different"}, nil)

	svc, err := NewService(
		WithSSHDir(tmpDir),
		WithAgentChecker(mockAgent),
	)
	require.NoError(t, err)

	key, err := svc.Get(context.Background(), "not_in_agent")
	require.NoError(t, err)
	assert.False(t, key.InAgent)

	mockAgent.AssertExpectations(t)
}

func TestParseKeyType(t *testing.T) {
	tests := []struct {
		input    string
		expected KeyType
	}{
		{"ssh-rsa", KeyTypeRSA},
		{"ssh-ed25519", KeyTypeED25519},
		{"ecdsa-sha2-nistp256", KeyTypeECDSA},
		{"ecdsa-sha2-nistp384", KeyTypeECDSA},
		{"ecdsa-sha2-nistp521", KeyTypeECDSA},
		{"sk-ssh-ed25519@openssh.com", KeyTypeED25519SK},
		{"sk-ecdsa-sha2-nistp256@openssh.com", KeyTypeECDSASK},
		{"unknown-type", KeyTypeUnknown},
	}

	for _, tt := range tests {
		t.Run(tt.input, func(t *testing.T) {
			result := parseKeyType(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestValidateKeyName(t *testing.T) {
	tmpDir := t.TempDir()
	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	tests := []struct {
		name      string
		expectErr bool
	}{
		{"valid_key", false},
		{"my-key", false},
		{"key123", false},
		{"", true},
		{"path/key", true},
		{"path\\key", true},
		{".hidden", true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := svc.validateKeyName(tt.name)
			if tt.expectErr {
				assert.Error(t, err)
			} else {
				assert.NoError(t, err)
			}
		})
	}
}

func TestShouldSkipFile(t *testing.T) {
	tmpDir := t.TempDir()
	svc, err := NewService(WithSSHDir(tmpDir))
	require.NoError(t, err)

	tests := []struct {
		name       string
		shouldSkip bool
	}{
		{"config", true},
		{"known_hosts", true},
		{"authorized_keys", true},
		{"environment", true},
		{".hidden", true},
		{"id_rsa.pub", true},
		{"id_rsa", false},
		{"my_key", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := svc.shouldSkipFile(tt.name)
			assert.Equal(t, tt.shouldSkip, result)
		})
	}
}
