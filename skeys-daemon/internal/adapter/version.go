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

package adapter

import (
	"context"
	"runtime"

	"google.golang.org/protobuf/types/known/emptypb"

	skeyscore "github.com/automationaddict/skeys-core"
	pb "github.com/automationaddict/skeys-daemon/api/gen/skeys/v1"
)

// VersionServiceAdapter implements the gRPC VersionService
type VersionServiceAdapter struct {
	pb.UnimplementedVersionServiceServer

	version string
	commit  string
}

// NewVersionServiceAdapter creates a new VersionServiceAdapter
func NewVersionServiceAdapter(version, commit string) *VersionServiceAdapter {
	return &VersionServiceAdapter{
		version: version,
		commit:  commit,
	}
}

// GetVersion returns version information about the daemon
func (a *VersionServiceAdapter) GetVersion(ctx context.Context, req *emptypb.Empty) (*pb.VersionInfo, error) {
	return &pb.VersionInfo{
		DaemonVersion: a.version,
		DaemonCommit:  a.commit,
		GoVersion:     runtime.Version(),
		CoreVersion:   skeyscore.Version,
		CoreCommit:    skeyscore.Commit,
	}, nil
}
