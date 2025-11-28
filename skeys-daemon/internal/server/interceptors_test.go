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

package server

import (
	"bytes"
	"context"
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/automationaddict/skeys-core/logging"
)

func TestNewLoggingInterceptor(t *testing.T) {
	var buf bytes.Buffer
	log := logging.New(logging.Config{Level: "info", Output: &buf})

	interceptor := newLoggingInterceptor(log)
	require.NotNil(t, interceptor)
}

func TestLoggingInterceptor_Success(t *testing.T) {
	var buf bytes.Buffer
	log := logging.New(logging.Config{Level: "info", Output: &buf})
	interceptor := newLoggingInterceptor(log)

	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return "success", nil
	}

	info := &grpc.UnaryServerInfo{
		FullMethod: "/skeys.v1.VersionService/GetVersion",
	}

	resp, err := interceptor(context.Background(), "request", info, handler)
	require.NoError(t, err)
	assert.Equal(t, "success", resp)

	// Check that log contains the method and OK status
	output := buf.String()
	assert.Contains(t, output, "/skeys.v1.VersionService/GetVersion")
	assert.Contains(t, output, "OK")
}

func TestLoggingInterceptor_Error(t *testing.T) {
	var buf bytes.Buffer
	log := logging.New(logging.Config{Level: "warn", Output: &buf})
	interceptor := newLoggingInterceptor(log)

	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return nil, status.Error(codes.NotFound, "key not found")
	}

	info := &grpc.UnaryServerInfo{
		FullMethod: "/skeys.v1.KeyService/GetKey",
	}

	resp, err := interceptor(context.Background(), "request", info, handler)
	require.Error(t, err)
	assert.Nil(t, resp)

	// Check that log contains the method and error status
	output := buf.String()
	assert.Contains(t, output, "/skeys.v1.KeyService/GetKey")
	assert.Contains(t, output, "NotFound")
	assert.Contains(t, output, "key not found")
}

func TestLoggingInterceptor_InternalError(t *testing.T) {
	var buf bytes.Buffer
	log := logging.New(logging.Config{Level: "warn", Output: &buf})
	interceptor := newLoggingInterceptor(log)

	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return nil, status.Error(codes.Internal, "database connection failed")
	}

	info := &grpc.UnaryServerInfo{
		FullMethod: "/skeys.v1.MetadataService/GetKeyMetadata",
	}

	resp, err := interceptor(context.Background(), "request", info, handler)
	require.Error(t, err)
	assert.Nil(t, resp)

	// Check that log contains the error details
	output := buf.String()
	assert.Contains(t, output, "Internal")
	assert.Contains(t, output, "database connection failed")
}

func TestLoggingInterceptor_NonGrpcError(t *testing.T) {
	var buf bytes.Buffer
	log := logging.New(logging.Config{Level: "warn", Output: &buf})
	interceptor := newLoggingInterceptor(log)

	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return nil, errors.New("plain error")
	}

	info := &grpc.UnaryServerInfo{
		FullMethod: "/skeys.v1.KeyService/ListKeys",
	}

	resp, err := interceptor(context.Background(), "request", info, handler)
	require.Error(t, err)
	assert.Nil(t, resp)

	// Check that log handles non-gRPC errors gracefully
	output := buf.String()
	assert.Contains(t, output, "/skeys.v1.KeyService/ListKeys")
}

func TestLoggingInterceptor_LogsDuration(t *testing.T) {
	var buf bytes.Buffer
	log := logging.New(logging.Config{Level: "info", Output: &buf})
	interceptor := newLoggingInterceptor(log)

	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return "success", nil
	}

	info := &grpc.UnaryServerInfo{
		FullMethod: "/skeys.v1.VersionService/GetVersion",
	}

	_, err := interceptor(context.Background(), "request", info, handler)
	require.NoError(t, err)

	// Check that log contains duration information
	output := buf.String()
	assert.Contains(t, output, "duration_ms")
}
