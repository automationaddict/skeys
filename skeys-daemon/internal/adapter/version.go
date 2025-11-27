package adapter

import (
	"context"
	"runtime"

	"google.golang.org/protobuf/types/known/emptypb"

	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
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
	}, nil
}
