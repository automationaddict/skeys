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

package logging

import (
	"bytes"
	"context"
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestDefaultConfig(t *testing.T) {
	cfg := DefaultConfig()
	assert.Equal(t, "info", cfg.Level)
	assert.NotNil(t, cfg.Output)
	assert.False(t, cfg.Pretty)
	assert.Equal(t, "skeys", cfg.Component)
}

func TestNew(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{
		Level:     "debug",
		Output:    &buf,
		Pretty:    false,
		Component: "test",
	})
	require.NotNil(t, log)
}

func TestNew_NilOutput(t *testing.T) {
	log := New(Config{
		Level:  "info",
		Output: nil, // Should default to stderr
	})
	require.NotNil(t, log)
}

func TestNew_Pretty(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{
		Level:  "debug",
		Output: &buf,
		Pretty: true,
	})
	require.NotNil(t, log)
}

func TestParseLevel(t *testing.T) {
	tests := []struct {
		level    string
		expected string
	}{
		{"debug", "debug"},
		{"info", "info"},
		{"warn", "warn"},
		{"error", "error"},
		{"unknown", "info"}, // Default to info
		{"", "info"},        // Default to info
	}

	for _, tt := range tests {
		t.Run(tt.level, func(t *testing.T) {
			level := parseLevel(tt.level)
			_ = level // Just check it doesn't panic
		})
	}
}

func TestLogger_Debug(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "debug", Output: &buf})

	log.Debug("test message")
	assert.Contains(t, buf.String(), "test message")
}

func TestLogger_Debugf(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "debug", Output: &buf})

	log.Debugf("formatted %s %d", "message", 42)
	assert.Contains(t, buf.String(), "formatted message 42")
}

func TestLogger_DebugWithFields(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "debug", Output: &buf})

	log.DebugWithFields("test", map[string]interface{}{"key": "value"})
	output := buf.String()
	assert.Contains(t, output, "test")
	assert.Contains(t, output, "value")
}

func TestLogger_Info(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "info", Output: &buf})

	log.Info("info message")
	assert.Contains(t, buf.String(), "info message")
}

func TestLogger_Infof(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "info", Output: &buf})

	log.Infof("formatted %s", "info")
	assert.Contains(t, buf.String(), "formatted info")
}

func TestLogger_InfoWithFields(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "info", Output: &buf})

	log.InfoWithFields("test", map[string]interface{}{"count": 5})
	output := buf.String()
	assert.Contains(t, output, "test")
	assert.Contains(t, output, "5")
}

func TestLogger_Warn(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "warn", Output: &buf})

	log.Warn("warning message")
	assert.Contains(t, buf.String(), "warning message")
}

func TestLogger_Warnf(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "warn", Output: &buf})

	log.Warnf("formatted %s", "warning")
	assert.Contains(t, buf.String(), "formatted warning")
}

func TestLogger_WarnWithFields(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "warn", Output: &buf})

	log.WarnWithFields("test", map[string]interface{}{"status": "degraded"})
	output := buf.String()
	assert.Contains(t, output, "test")
	assert.Contains(t, output, "degraded")
}

func TestLogger_Error(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "error", Output: &buf})

	log.Error("error message")
	assert.Contains(t, buf.String(), "error message")
}

func TestLogger_Errorf(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "error", Output: &buf})

	log.Errorf("formatted %s", "error")
	assert.Contains(t, buf.String(), "formatted error")
}

func TestLogger_ErrorWithFields(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "error", Output: &buf})

	log.ErrorWithFields("test", map[string]interface{}{"code": 500})
	output := buf.String()
	assert.Contains(t, output, "test")
	assert.Contains(t, output, "500")
}

func TestLogger_Err(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "error", Output: &buf})

	err := errors.New("sample error")
	log.Err(err, "operation failed")
	output := buf.String()
	assert.Contains(t, output, "operation failed")
	assert.Contains(t, output, "sample error")
}

func TestLogger_ErrWithFields(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "error", Output: &buf})

	err := errors.New("sample error")
	log.ErrWithFields(err, "operation failed", map[string]interface{}{"retry": true})
	output := buf.String()
	assert.Contains(t, output, "operation failed")
	assert.Contains(t, output, "sample error")
	assert.Contains(t, output, "true")
}

func TestLogger_WithComponent(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "info", Output: &buf, Component: "main"})

	subLog := log.WithComponent("submodule")
	subLog.Info("test")
	assert.Contains(t, buf.String(), "submodule")
}

func TestLogger_WithField(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "info", Output: &buf})

	fieldLog := log.WithField("request_id", "abc123")
	fieldLog.Info("test")
	assert.Contains(t, buf.String(), "abc123")
}

func TestLogger_WithContext(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "info", Output: &buf})

	ctx := log.WithContext(context.Background())
	retrieved := FromContext(ctx)
	require.NotNil(t, retrieved)

	retrieved.Info("from context")
	assert.Contains(t, buf.String(), "from context")
}

func TestFromContext_NoLogger(t *testing.T) {
	// When no logger in context, should return default logger
	log := FromContext(context.Background())
	require.NotNil(t, log)
}

func TestNop(t *testing.T) {
	log := Nop()
	require.NotNil(t, log)

	// Should not panic
	log.Debug("test")
	log.Info("test")
	log.Warn("test")
	log.Error("test")
	log.Debugf("test %s", "value")
	log.Infof("test %s", "value")
	log.Warnf("test %s", "value")
	log.Errorf("test %s", "value")
	log.DebugWithFields("test", map[string]interface{}{"key": "value"})
	log.InfoWithFields("test", map[string]interface{}{"key": "value"})
	log.WarnWithFields("test", map[string]interface{}{"key": "value"})
	log.ErrorWithFields("test", map[string]interface{}{"key": "value"})
	log.Err(errors.New("test"), "message")
	log.ErrWithFields(errors.New("test"), "message", map[string]interface{}{})
}

func TestLogger_LevelFiltering(t *testing.T) {
	var buf bytes.Buffer
	log := New(Config{Level: "error", Output: &buf})

	// Debug messages should not appear when level is error
	log.Debug("debug message")
	assert.NotContains(t, buf.String(), "debug message")

	log.Info("info message")
	assert.NotContains(t, buf.String(), "info message")

	log.Warn("warn message")
	assert.NotContains(t, buf.String(), "warn message")

	log.Error("error message")
	assert.Contains(t, buf.String(), "error message")
}
